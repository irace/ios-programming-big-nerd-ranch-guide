//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Bryan Irace on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

#pragma mark -
#pragma mark Defined in UIView

- (id)initWithCoder:(NSCoder *)coder {
    [super initWithCoder:coder];
    linesInProcess = [[NSMutableDictionary alloc] init];
    completeLines = [[NSMutableArray alloc] init];
    [self setMultipleTouchEnabled:YES];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    [[UIColor blackColor] set];
    for (Line *line in completeLines) {
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    // Draw lines in process in red
    [[UIColor redColor] set];
    for (NSValue *v in linesInProcess) {
        Line *line = [linesInProcess objectForKey:v];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    float f = 0.0;
    for (int i = 0; i < 1000; i++) {
        f = f + sin(sin(time(NULL) + i));
    }
    
    NSLog(@"f = %f", f);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // Is this a double tap?
        if ([touch tapCount] > 1) {
            [self clearAll];
            return;
        }
        
        // Use the touch object (packed in an NSValue) as the key
        NSValue *key = [NSValue valueWithPointer:touch];
        
        // Create a line for the value
        CGPoint loc = [touch locationInView:self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        
        // Put pair in dictionary
        [linesInProcess setObject:newLine forKey:key];
        
        [newLine release];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // Update linesInProcess with moved touches
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithPointer:touch];
        
        // Find the line for this touch
        Line *line = [linesInProcess objectForKey:key];
        
        // Update the line
        CGPoint loc = [touch locationInView:self];
        [line setEnd:loc];
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

#pragma mark -
#pragma mark Private methods

- (void)clearAll {
    // Clear the containers
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches {
    // Remove ending touches from dictionary
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithPointer:touch];
        Line *line = [linesInProcess objectForKey:key];
        
        // If this is a double tap, 'line' will be nil
        if (line) {
            [completeLines addObject:line];
            [linesInProcess removeObjectForKey:key];
        }
    }
    
    // Redraw
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Defined in NSObject

- (void)dealloc {
    [linesInProcess release];
    [completeLines release];
    
    [super dealloc];
}


@end
