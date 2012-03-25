//
//  CurrentTimeViewController.m
//  HypnoTime
//
//  Created by Bryan Irace on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CurrentTimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CurrentTimeViewController

#pragma mark -
#pragma mark Defined in header

- (IBAction)showCurrentTime:(id)sender {
    NSDate *now = [NSDate date];
    
    static NSDateFormatter *formatter = nil;
    
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    [timeLabel setText:[formatter stringFromDate:now]];
    
//    // Create a basic animation
//    CABasicAnimation *spin = [CABasicAnimation 
//                              animationWithKeyPath:@"transform.rotation"];
//    
//    // fromValue is implied - will use the current value
//    [spin setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
//    [spin setDuration:1.0];
//    
//    // Set the timing function
//    CAMediaTimingFunction *tf = 
//            [CAMediaTimingFunction 
//             functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    
//    [spin setTimingFunction:tf];
//    
//    [spin setDelegate:self];
//    
//    // Kick off the animation by adding it to the layer
//    [[timeLabel layer] addAnimation:spin forKey:@"spinAnimation"];
    
    // Create a key frame animation
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation 
                                   animationWithKeyPath:@"transform"];
    
    // Create the values it will pass through
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    
    [bounce setValues:[NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                       [NSValue valueWithCATransform3D:forward],
                       [NSValue valueWithCATransform3D:back],
                       [NSValue valueWithCATransform3D:forward2],
                       [NSValue valueWithCATransform3D:back2],
                       [NSValue valueWithCATransform3D:CATransform3DIdentity],
                       nil]];
    
    // Set the duration
    [bounce setDuration:0.6];
    
    // Animate the layer
    [[timeLabel layer] addAnimation:bounce forKey:@"bounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"%@ finished: %d", anim, flag);
}

#pragma mark -
#pragma mark Defined in UIViewControler

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCurrentTime:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	return [self init];
}

- (void)viewDidUnload {
    [super viewDidUnload];

    [timeLabel release];
    timeLabel = nil;
}

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
	[super initWithNibName:@"CurrentTimeViewController" bundle:nil];
	UITabBarItem *tabBarItem = [self tabBarItem];
    
    [tabBarItem setTitle:@"Time"];
    
    UIImage *image = [UIImage imageNamed:@"Time.png"];
    [tabBarItem setImage:image];
    
	return self;
}

- (void)dealloc {
    [timeLabel release];
    
    [super dealloc];
}


@end
