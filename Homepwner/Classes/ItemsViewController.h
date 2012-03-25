//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Bryan Irace on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemDetailViewController;

@interface ItemsViewController : UITableViewController {
    UIView *headerView;
    NSMutableArray *possessions;
    ItemDetailViewController *itemDetailViewController;
}

@property (nonatomic, retain) NSMutableArray *possessions;

@end
