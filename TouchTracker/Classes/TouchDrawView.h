//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Bryan Irace on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchDrawView : UIView {
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
}

@end
