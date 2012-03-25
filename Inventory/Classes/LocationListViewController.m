//
//  LocationListViewController.m
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationListViewController.h"
#import "AppController.h"
#import "LabelSettingViewController.h"
#import "AssetListViewController.h"

@implementation LocationListViewController

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        AppController *ac = [AppController sharedController];
        NSArray *list = [ac allInstancesOf:@"Location" orderedBy:@"label"];
        locationList = [list mutableCopy];
        
        [self setTitle:@"Locations"];
        
        // Create the "Add" navigation item
        UIBarButtonItem *item = [[[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(createNewLocation:)] autorelease];
        
        [[self navigationItem] setRightBarButtonItem:item];
    }
    
    return self;
}

- (void)dealloc {
    [locationList release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Targeted by action selectors

- (void)createNewLocation:(id)sender {
    labelSettingViewController = [[LabelSettingViewController alloc] init];
    [[self navigationController] pushViewController:labelSettingViewController animated:YES];
}

#pragma mark -
#pragma mark Defined in UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Am I coming back from the LabelSettingViewController?
    if (labelSettingViewController) {
        NSString *value = [labelSettingViewController value];
        
        // Did the user give a value for the label?
        
        if ([value length] > 0) {
            AppController *ac = [AppController sharedController];
            NSManagedObjectContext *moc = [ac managedObjectContext];
            
            // Create a new object and insert it into the managed object context
            NSManagedObject *newLoc = [NSEntityDescription 
                                       insertNewObjectForEntityForName:@"Location" 
                                       inManagedObjectContext:moc];
            
            [newLoc setValue:value forKey:@"label"];
            [locationList addObject:newLoc];
            
            // Resort the array
            NSSortDescriptor *sd = [[[NSSortDescriptor alloc] initWithKey:@"label" 
                                                               ascending:YES] autorelease];
            
            [locationList sortUsingDescriptors:[NSArray arrayWithObject:sd]];
            
            // Redisplay the table view
            [[self tableView] reloadData];
        }
        
        [labelSettingViewController release];
        labelSettingViewController = nil;
    }
    
    // Clear the selection
    NSIndexPath *selectedPath = [[self tableView] indexPathForSelectedRow];
    
    if (selectedPath) {
        [[self tableView] deselectRowAtIndexPath:selectedPath animated:NO];
    }
}

#pragma mark -
#pragma mark Defined in UITableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

#pragma mark -
#pragma mark Defined in UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section {
    return [locationList count];
}

- (UITableViewCell *) tableView:(UITableView *)tv 
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LocationCell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSManagedObject *location = [locationList objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[location valueForKey:@"label"]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark -
#pragma mark Defined in UITableViewDelegate

- (void) tableView:(UITableView *)tv 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetListViewController *alvc = [[[AssetListViewController alloc] init] autorelease];
    [alvc setLocation:[locationList objectAtIndex:[indexPath row]]];
    
    [[self navigationController] pushViewController:alvc animated:YES];
}

@end

