//
//  HomepwnerAppDelegate.h
//  Homepwner
//
//  Created by Bryan Irace on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemsViewController;

@interface HomepwnerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ItemsViewController *itemsViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSString *)possessionArrayPath;

@end

