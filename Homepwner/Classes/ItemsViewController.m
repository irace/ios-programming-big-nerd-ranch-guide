//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Bryan Irace on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "Possession.h"
#import "ItemDetailViewController.h"
#import "HomepwnerItemCell.h"

@implementation ItemsViewController

@synthesize possessions;

- (id)init {
    // Call the superclass's designated initializer
    [super initWithStyle:UITableViewStyleGrouped];

    // Set the nav bad to have the pre-fab'ed Edit button when
    // ItemsViewController is on top of the stack
    [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    
    // Set the title of the nav bar to Homepwner when ItemsViewController
    // is on top of the stack
    [[self navigationItem] setTitle:@"Homepwner"];
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

-  (NSInteger)tableView:(UITableView *)tableView 
   numberOfRowsInSection:(NSInteger)section {
   
    int numRows = [possessions count];
    
    if ([self isEditing]) {
        numRows++;
    }
    
    return numRows;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // This will occur when editing, extra row that shows "Add New Item..."
    if ([indexPath row] >= [possessions count]) {
        // Create a basic cell
        UITableViewCell *basicCell = 
                [tableView dequeueReusableCellWithIdentifier:
                 @"UITableViewCell"];
        
        if (!basicCell) {
            basicCell = [[UITableViewCell alloc] 
                         initWithStyle:UITableViewCellStyleDefault 
                         reuseIdentifier:@"UITableViewCell"];
        }
            
        // Set the textLabel of the basic cell from a strings table lookup
        [[basicCell textLabel] setText:NSLocalizedString(@"AddNewItem", @"textLabel for add cell: Add New Item...")];
        return basicCell;
    }
    
    // Get instance of HomepwnerItemCell - either an unused one or a new one
    HomepwnerItemCell *cell = (HomepwnerItemCell *)
            [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    if (!cell) {
        cell = [[HomepwnerItemCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:@"UITableViewCell"];
    }
    
    // Instead of setting each label directly, we pass it a possession object
    // It knows how to configure its own subviews
    Possession *p = [possessions objectAtIndex:[indexPath row]];
    [cell setPossession:p];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the row being deleted from the possessions array
        [possessions removeObjectAtIndex:[indexPath row]];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // If the editing style of the row was insertion,
        // we add a new possession object and now row to the table value
        [possessions addObject:[Possession randomPossession]];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([indexPath row] < [possessions count]);
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([proposedDestinationIndexPath row] < [possessions count]) {
        // If we are moving to a row that is currently showing a possession
        // then we return the row the user wanted to move to
        return proposedDestinationIndexPath;
    } else {
        return [NSIndexPath indexPathForRow:[possessions count] - 1 inSection:0];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Possession *possession = [possessions objectAtIndex:[sourceIndexPath row]];
        
    // Retain so that it is not deallocated when it is removed from the array
    [possession retain];
    // Retain count is now two
        
    [possessions removeObjectAtIndex:[sourceIndexPath row]];
    // Retain count is now one
        
    // Re-insert p into array at new location, it is automatically retained
    [possessions insertObject:possession atIndex:[destinationIndexPath row]];
    // Retain count is now two
        
    [possession release];
    // Retain count is now one
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    // Always call super implementation of this method, it needs to do work
    [super setEditing:editing animated:animated];
    
    // You need to insert/remove a new row in to table
    if (editing) {
        // If entering editing mode, we add another row to our table view
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
        
        NSArray *paths = [NSArray arrayWithObject:indexPath];
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        // If leaving editing mode, we remove last row from the table
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
        NSArray *paths = [NSArray arrayWithObject:indexPath];
        
        [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isEditing] && [indexPath row] == [possessions count]) {
        // The last row during editing will show an insert style button
        return UITableViewCellEditingStyleInsert;
    }
    
    // All other rows remain deleteable
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do I need to create the instance of ItemDetailViewController?
    if (!itemDetailViewController) {
        itemDetailViewController = [[ItemDetailViewController alloc] init];        
    }
    
    [itemDetailViewController setPossession:[possessions objectAtIndex:[indexPath row]]];
    [[self navigationController] pushViewController:itemDetailViewController animated:YES];
}

@end
