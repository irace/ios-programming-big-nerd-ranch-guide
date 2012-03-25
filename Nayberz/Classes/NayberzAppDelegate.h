//
//  NayberzAppDelegate.h
//  Nayberz
//
//  Created by Bryan Irace on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableController;

@interface NayberzAppDelegate : NSObject <UIApplicationDelegate, 
        NSNetServiceDelegate> {
    UIWindow *window;
    NSNetService *netService;
    TableController *tableController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

