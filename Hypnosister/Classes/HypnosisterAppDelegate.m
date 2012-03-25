//
//  HypnosisterAppDelegate.m
//  Hypnosister
//
//  Created by Bryan Irace on 10/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HypnosisterAppDelegate.h"
#import "HypnosisView.h"

@implementation HypnosisterAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	CGRect wholeWindow = [window bounds];
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:wholeWindow];
	[window addSubview:scrollView];
	[scrollView release];
	
	// Make your view twice as large as the window
	CGRect reallyBigRect;
	reallyBigRect.origin = CGPointZero;
	reallyBigRect.size.width = wholeWindow.size.width * 2.0;
	reallyBigRect.size.height = wholeWindow.size.height * 2.0;
	[scrollView setContentSize:reallyBigRect.size];
	
	// Center it in the scroll view
	CGPoint offset;
	offset.x = wholeWindow.size.width * 0.5;
	offset.y = wholeWindow.size.height * 0.5;
	[scrollView setContentOffset:offset];
	
	// Enable zooming
	[scrollView setMinimumZoomScale:0.5];
	[scrollView setMinimumZoomScale:0.5];
	[scrollView setDelegate:self];
	
	// Create the view
	view = [[HypnosisView alloc] initWithFrame:reallyBigRect];
	[view setBackgroundColor:[UIColor clearColor]];
	[scrollView addSubview:view];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES
												 animated:NO];
	
	[window makeKeyAndVisible];
	return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return view;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
