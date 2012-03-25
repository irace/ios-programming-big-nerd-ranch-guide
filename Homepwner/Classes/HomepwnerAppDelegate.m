//
//  HomepwnerAppDelegate.m
//  Homepwner
//
//  Created by Bryan Irace on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomepwnerAppDelegate.h"
#import "ItemsViewController.h"

@implementation HomepwnerAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Defined in header

- (NSString *)possessionArrayPath {
    return pathInDocumentDirectory(@"Possessions.data");
}

#pragma mark -
#pragma mark Defined in UIApplicationDelegate

- (BOOL)application:(UIApplication *)application 
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Get the full path of our possession archive file
    NSString *possessionPath = [self possessionArrayPath];
    
    // Unarchive it into an array
    NSMutableArray *possessionArray = [NSKeyedUnarchiver 
                                       unarchiveObjectWithFile:possessionPath];
    
    // If the file did not exist, our possession array will not either
    // Create one in its absence
    if (!possessionArray) {
        possessionArray = [NSMutableArray array];
    }
    
    itemsViewController = [[ItemsViewController alloc] init];
    [itemsViewController setPossessions:possessionArray];

    // Create an instance of UINavigationController
    // It's stack contains only itemsViewController
    UINavigationController *navController = 
            [[UINavigationController alloc] 
             initWithRootViewController:itemsViewController];
        
    // Place ItemsViewController's table view in the window hierarchy
    [window addSubview:[navController view]];
    
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Get full path of possession archive
    NSString *possessionPath = [self possessionArrayPath];
    
    // Get the possession list
    NSMutableArray *possessionArray = [itemsViewController possessions];
    
    // Archive possession list to file
    [NSKeyedArchiver archiveRootObject:possessionArray toFile:possessionPath];
}

#pragma mark -
#pragma mark Defined in NSObject

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
