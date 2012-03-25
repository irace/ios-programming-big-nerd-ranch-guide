//
//  AssetListViewController.m
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetListViewController.h"
#import "AppController.h"
#import "LabelSettingViewController.h"
#import "CountViewController.h"

// All instances of AssetListViewController will share a single instance of NSDateFormatter
static NSDateFormatter *dateFormatter;

@implementation AssetListViewController

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        AppController *ac = [AppController sharedController];
        
        // Fetch all the assets
        NSArray *list = [ac allInstancesOf:@"Asset" orderedBy:@"label"];
        assetList = [list mutableCopy];
        
        // Set the navigation item
        UIBarButtonItem *item = 
                [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                              target:self
                                                               action:@selector(createNewAsset:)] autorelease];
        
        [[self navigationItem] setRightBarButtonItem:item];
        
        // Is the date formatter nil?
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        }
    }
    
    return self;
}

- (void)dealloc {
    [location release];
    [assetList release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Defined in UITableViewController

- (id) initWithStyle:(UITableViewStyle)style {
    return [self init];
}

#pragma mark -
#pragma mark Defined in header

- (NSManagedObject *)inventoryForAsset:(NSManagedObject *)asset {
    NSArray *inventoriesForLocation = [location valueForKey:@"inventories"];
    
    for (NSManagedObject *mo in inventoriesForLocation) {
        if ([mo valueForKey:@"asset"] == asset) {
            return mo;
        }
    }
    
    return nil;
}

- (void)setLocation:(NSManagedObject *)l {
    [location release];
    
    location = [l retain];
    
    [self setTitle:[location valueForKey:@"label"]];
}

#pragma mark -
#pragma mark Targeted by action selectors

- (void)createNewAsset:(id)sender {
    labelSettingViewController = [[LabelSettingViewController alloc] init];
    [[self navigationController] pushViewController:labelSettingViewController 
                                           animated:YES];
}

#pragma mark -
#pragma mark Defined in UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Am I coming from the label setting view controller?
    if (labelSettingViewController) {
        NSString *value = [labelSettingViewController value];
        
        // Was a value set?
        if ([value length] > 0) {
            AppController *ac = [AppController sharedController];
            NSManagedObjectContext *moc = [ac managedObjectContext];
            
            NSManagedObject *newAsset = 
                    [NSEntityDescription insertNewObjectForEntityForName:@"Asset"
                                                  inManagedObjectContext:moc];
            
            [newAsset setValue:value forKey:@"label"];
            [assetList addObject:newAsset];
            
            [assetList sortUsingDescriptors:
             [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"label" 
                                                                    ascending:YES]]];
            
            [[self tableView] reloadData];
        }
        
        [labelSettingViewController release];
        labelSettingViewController = nil;
    }
    
    if (countViewController) {
        NSNumber *count = [countViewController count];
        
        if (count) {
            NSManagedObject *asset = [countViewController asset];
            NSManagedObject *inventory = [self inventoryForAsset:asset];
            
            if (!inventory) {
                AppController *ac = [AppController sharedController];
                NSManagedObjectContext *moc = [ac managedObjectContext];
                
                inventory = [NSEntityDescription 
                             insertNewObjectForEntityForName:@"Inventory"
                             inManagedObjectContext:moc];
                
                [[asset mutableSetValueForKey:@"inventories"] addObject:inventory];
                
                // The inverse relationship is set automatically, thus this line:
                // [inventory setValue:asset forKey:@"asset"];
                // is unnecessary
                
                [[location mutableSetValueForKey:@"inventories"] addObject:inventory];
            }
            
            [inventory setValue:count forKey:@"count"];
            NSDate *now = [NSDate date];
            [inventory setValue:now forKey:@"date"];
            
            [[self tableView] reloadData];
        }
        
        [countViewController release];
        countViewController = nil;
    }
    
    NSIndexPath *selectedPath = [[self tableView] indexPathForSelectedRow];
    
    if (selectedPath) {
        [[self tableView] deselectRowAtIndexPath:selectedPath animated:NO];
    }
}

#pragma mark -
#pragma mark Defined in UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv 
 numberOfRowsInSection:(NSInteger)section {
    return [assetList count];
}

- (UITableViewCell *) tableView:(UITableView *)tv 
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSManagedObject *asset = [assetList objectAtIndex:[indexPath row]];
    NSManagedObject *inventory = [self inventoryForAsset:asset];
    
    NSString *assetName = [asset valueForKey:@"label"];
    
    if (inventory) {
        NSDate *date = [inventory valueForKey:@"date"];
        NSString *inventorySummary = [NSString stringWithFormat:@"%@ %@ - %@",
                                      [inventory valueForKey:@"count"],
                                      assetName,
                                      [dateFormatter stringFromDate:date]];
        
        [[cell textLabel] setText:inventorySummary];
    } else {
        [[cell textLabel] setText:assetName];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark -
#pragma mark Defined in UITableViewDelegate

- (void) tableView:(UITableView *)tv 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    countViewController = [[CountViewController alloc] init];
    [countViewController setLocation:location];
    [countViewController setAsset:[assetList objectAtIndex:[indexPath row]]];
     
    [[self navigationController] pushViewController:countViewController 
                                           animated:YES];
}

@end

