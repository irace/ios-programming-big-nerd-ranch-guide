//
//  AssetListViewController.h
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LabelSettingViewController;
@class CountViewController;

@interface AssetListViewController : UITableViewController {
    NSManagedObject *location;
    NSMutableArray *assetList;
    LabelSettingViewController *labelSettingViewController;
    CountViewController *countViewController;
}

- (NSManagedObject *)inventoryForAsset:(NSManagedObject *)asset;
- (void)setLocation:(NSManagedObject *)l;

@end
