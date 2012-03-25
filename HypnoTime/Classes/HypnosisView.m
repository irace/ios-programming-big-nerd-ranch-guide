//
//  HypnosisView.m
//  Hypnosister
//
//  Created by Bryan Irace on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView

@synthesize xShift, yShift;

#pragma mark -
#pragma mark Defined in UIView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [boxLayer setPosition:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    [CATransaction begin];

    [CATransaction setValue:[NSNumber numberWithBool:YES] 
                     forKey:kCATransactionDisableActions];
    
    [boxLayer setPosition:p];
    
    [CATransaction commit];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        stripeColor = [[UIColor lightGrayColor] retain];
        
        // Create the new layer object
        boxLayer = [[CALayer alloc] init];
        
        // Give it a size
        [boxLayer setBounds:CGRectMake(0.0, 0.0, 85.0, 85.0)];
        
        // Give it a location
        [boxLayer setPosition:CGPointMake(160.0, 100.0)];
        
        // Make half-transparent red the background color for the layer
        UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 
                                           alpha:0.5];
        
        // Get a CGColor object with the same color values
        CGColorRef cgReddish = [reddish CGColor];
        [boxLayer setBackgroundColor:cgReddish];
        
        // Make it a subview of the view's layer
        [[self layer] addSublayer:boxLayer];
        
        // boxLayer is retained by its superlayer
        [boxLayer release];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // What rectangle am I filling?
	CGRect bounds = [self bounds];
	
	// Where is its center?
	CGPoint center;
	center.x = bounds.origin.x + bounds.size.width/2.0;
	center.y = bounds.origin.y + bounds.size.height/2.0;
	
	// From the center how far out to a corner
	float maxRadius = hypot(bounds.size.width, bounds.size.height)/2.0;
	
	// Get the context being drawn upon
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// All lines will be drawn 10 points wide
	CGContextSetLineWidth(context, 10);
    
    [stripeColor setStroke];
	
	// Draw concentric circles from the outside in
	for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        center.x += xShift;
        center.y += yShift;
        
		CGContextAddArc(context, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
		CGContextStrokePath(context);
	}
	
	// Create a string
	NSString *text = @"You are getting sleepy.";
	
	// Get a font to draw it in
	UIFont *font = [UIFont boldSystemFontOfSize:28];
	
	// Where am I going to draw it?
	CGRect textRect;
	textRect.size = [text sizeWithFont:font];
	textRect.origin.x = center.x - textRect.size.width/2.0;
	textRect.origin.y = center.y - textRect.size.height/2.0;
	
	// Set the fill color
	[[UIColor blackColor] setFill];
	
	// Set the shadow
	CGSize offset = CGSizeMake(4, -3);
	CGColorRef color = [[UIColor darkGrayColor] CGColor];
	CGContextSetShadowWithColor(context, offset, 2.0, color);
	
	// Draw the string
	[text drawInRect:textRect withFont:font];
}

#pragma mark -
#pragma mark Defined in UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Shake started");
        float r, g, b;
        r = random() % 256 / 256.0;
        g = random() % 256 / 256.0;
        b = random() % 256 / 256.0;
        
        [stripeColor release];
        
        stripeColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [stripeColor retain];
        [self setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark Defined in NSObject

- (void)dealloc {
    [stripeColor release];
    [super dealloc];
}


@end
