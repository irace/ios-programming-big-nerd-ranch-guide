//
//  LocationListViewController.h
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LabelSettingViewController;

@interface LocationListViewController : UITableViewController {
    NSMutableArray *locationList;
    LabelSettingViewController *labelSettingViewController;
}

@end
