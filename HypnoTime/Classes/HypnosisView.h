//
//  HypnosisView.h
//  Hypnosister
//
//  Created by Bryan Irace on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HypnosisView : UIView {
    CALayer *boxLayer;
    UIColor *stripeColor;
    float xShift, yShift;
}

@property (nonatomic, assign) float xShift;
@property (nonatomic, assign) float yShift;

@end
