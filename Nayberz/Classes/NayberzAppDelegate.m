//
//  NayberzAppDelegate.m
//  Nayberz
//
//  Created by Bryan Irace on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NayberzAppDelegate.h"
#import "TableController.h"

@implementation NayberzAppDelegate

@synthesize window;

+ (void)initialize {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *pListPath = [path stringByAppendingPathComponent:@"Settings.bundle/Root.plist"];
    NSDictionary *pList = [NSDictionary dictionaryWithContentsOfFile:pListPath];
    
    NSMutableDictionary *preferences = [pList objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *dictionaryOfDefaults = [NSMutableDictionary dictionary];
    
    for (NSDictionary *preference in preferences) {
        NSString *key = [preference objectForKey:@"Key"];
        
        if (key) {
            id value = [preference objectForKey:@"DefaultValue"];
            [dictionaryOfDefaults setObject:value forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionaryOfDefaults];
}

#pragma mark -
#pragma mark Defined in NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"Published: %@", sender);
}

- (void)netService:(NSNetService *)sender 
     didNotPublish:(NSDictionary *)errorDict {
    NSLog(@"Not published: %@ -> %@", sender, errorDict);
}

#pragma mark -
#pragma mark Defined in UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Create an instance of NSNetService
    netService = [[NSNetService alloc] initWithDomain:@""
                                                 type:@"_nayberz._tcp."
                                                 name:[[UIDevice currentDevice] name] 
                                                 port:9090];
    
    // As the delegate, you will know if the publish is successful
    [netService setDelegate:self];
    
    // Get the shared instance of NSUserDefaults
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *messageString = [ud objectForKey:@"BNRMessagePrefKey"];
    
    // Pack the message string into an NSData object
    NSData *d = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Put the data into a dictionary
    NSDictionary *txtDict = [NSDictionary dictionaryWithObject:d 
                                                        forKey:@"message"];
    
    // Pack the dictionary into an NSData
    NSData *txtData = [NSNetService dataFromTXTRecordDictionary:txtDict];
    
    // Put that data into the net service
    
    [netService setTXTRecordData:txtData];
    
    // Try to publish it
    [netService publish];
    
    tableController = [[TableController alloc] init];
    [[tableController view] setFrame:[window bounds]];
    [window addSubview:[tableController view]];
    
    [application setStatusBarHidden:YES];
    
    [[self window] makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [netService stop];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

#pragma mark -
#pragma mark Defined in NSObject

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
