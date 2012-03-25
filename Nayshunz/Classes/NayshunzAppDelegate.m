//
//  NayshunzAppDelegate.m
//  Nayshunz
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NayshunzAppDelegate.h"

@implementation NayshunzAppDelegate

@synthesize window, countryTable, searchBar;

#pragma mark -
#pragma mark Defined in UIApplicationDelegage

- (BOOL)application:(UIApplication *)application 
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [[self window] makeKeyAndVisible];
    
    [searchBar becomeFirstResponder];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    sqlite3_close(database);
}

#pragma mark -
#pragma mark Defined in UISearchBarDelegate

- (void)searchBar:(UISearchBar *)sb
    textDidChange:(NSString *)searchText {
    
    // Clear the data structure
    [continents removeAllObjects];
    
    // Only search if user has entered something
    if ([searchText length] != 0) {
        // Does the statement need to be prepared?
        
        if (!statement) {
            // '?' is a placeholder for parameters
            char *cQuery = "SELECT Continent, Name, Code FROM Country WHERE Name LIKE ? ORDER BY Continent, Name";
            
            // Prepare the query
            if (sqlite3_prepare_v2(database, cQuery, -1, &statement, NULL) != SQLITE_OK) {
                NSLog(@"Query error: %s", statement);
            }
        }
        
        // Add % to the end of the search text
        searchText = [searchText stringByAppendingString:@"%"];
        
        NSLog(@"Searching for %@", searchText);
        
        // This C string will get cleaned up automatically
        const char *cSearchText = [searchText cStringUsingEncoding:NSUTF8StringEncoding];
        
        // Replace the first (and only) parameter with the search text
        sqlite3_bind_text(statement, 1, cSearchText, -1, SQLITE_TRANSIENT);
        
        NSString *lastContinentName = nil;
        NSMutableArray *currentNationList;
        
        // Loop to get all the rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
            // Get the string in the first column
            const char *cContinentName = (const char *)sqlite3_column_text(statement, 0);
            
            // Convert C string into an NSString
            NSString *continentName = [[NSString alloc] initWithUTF8String:cContinentName];
            
            // Is this a new continent name?
            if (!lastContinentName || ![lastContinentName isEqual:continentName]) {
                // Create an array for the nations of this new continent
                currentNationList = [[[NSMutableArray alloc] init] autorelease];
                
                // Put the name and the array in a dictionary
                NSDictionary *continentalDict = [[[NSDictionary alloc] initWithObjectsAndKeys:
                                                 continentName, 
                                                 @"name",
                                                 currentNationList,
                                                 @"list",
                                                 nil] autorelease];
                
                // Add the new continent to the array of continents
                [continents addObject:continentalDict];
            }
            
            lastContinentName = continentName;
            
            // Get the string in the second column
            const char *cCountryName = (const char *)sqlite3_column_text(statement, 1);
            
            // Convert the C string into an NSString
            NSString *countryName = [[NSString alloc] initWithUTF8String:cCountryName];

            // Get the string in the third column
            const char *cCountryCode = (const char *)sqlite3_column_text(statement, 2);
            
            // Convert the C string into an NSString
            NSString *countryCode = [[NSString alloc] initWithUTF8String:cCountryCode];
            
            // Creat a dictionary for this nation
            NSMutableDictionary *countryDict = 
                    [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     countryName,
                     @"name",
                     countryCode,
                     @"code",
                     nil];
            
            [currentNationList addObject:countryDict];
            
            NSLog(@"%@: %@ of %@", countryCode, countryName, continentName);
        }
        
        // Clear the query results
        sqlite3_reset(statement);
    }
    
    // Load the table with the new data
    [countryTable reloadData];
}

#pragma mark -
#pragma mark Defined in UITableViewDelegate

#pragma mark -
#pragma mark Defined in UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [continents count];
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    return [[continents objectAtIndex:section] objectForKey:@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [[[continents objectAtIndex:section] objectForKey:@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *country = [[[continents objectAtIndex:[indexPath section]] 
                              objectForKey:@"list"] 
                             objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [countryTable dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:@"Cell"] autorelease];
    }
    
    [[cell textLabel] setText:[country objectForKey:@"name"]];
    
    return cell;
}

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
    if (self = [super init]) {
        continents = [[NSMutableArray alloc] init];
        
        // Where do the documents go?
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                             NSUserDomainMask, 
                                                             YES);
        
        NSString *path = [paths objectAtIndex:0];
        
        // What would be the full name of my database file?
        NSString *fullPath = [path stringByAppendingPathComponent:@"countries.db"];
        
        // Get a file manager for file operations
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // Does the file already exist?
        BOOL exists = [fm fileExistsAtPath:fullPath];
        
        if (exists) {
            NSLog(@"%@ exists - just opening", fullPath);
        } else {
            NSLog(@"%@ does not exist - copying and opening", fullPath);
            
            // Where is the staring database in the application wrapper?
            NSString *pathForStartingDB = 
                    [[NSBundle mainBundle] pathForResource:@"countries"
                                                    ofType:@"db"];
            
            // Copy it to the documents directory
            BOOL success = [fm copyItemAtPath:pathForStartingDB
                                       toPath:fullPath 
                                        error:NULL];
            
            if (!success) {
                NSLog(@"Database copy failed");
            }
            
            // Open the database file
            const char *cFullPath = [fullPath cStringUsingEncoding:NSUTF8StringEncoding];
            
            if (sqlite3_open(cFullPath, &database) != SQLITE_OK) {
                NSLog(@"unable to open database at %@", fullPath);
            }
        }
    }
    
    return self;
}

- (void)dealloc {
    [window release];
    [countryTable release];
    [searchBar release];
    
    [continents release];
    
    [super dealloc];
}

@end
