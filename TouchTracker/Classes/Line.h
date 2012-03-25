//
//  Line.h
//  TouchTracker
//
//  Created by Bryan Irace on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject {
    CGPoint begin;
    CGPoint end;
}

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
