//
//  TopSongsAppDelegate.m
//  TopSongs
//
//  Created by Bryan Irace on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TopSongsAppDelegate.h"
#import "RSSTableViewController.h"

@implementation TopSongsAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Defined in UIAppplicationDelegate

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    RSSTableViewController *tvc = [[RSSTableViewController alloc] 
                                   initWithStyle:UITableViewStylePlain];
    
    [window addSubview:[tvc view]];
    
    [window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark Defined in NSObject

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
