//
//  HypnosisterAppDelegate.h
//  Hypnosister
//
//  Created by Bryan Irace on 10/19/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HypnosisView;

@interface HypnosisterAppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate> {
    UIWindow *window;
	HypnosisView *view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

