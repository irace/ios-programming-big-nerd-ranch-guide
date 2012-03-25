//
//  CurrentTimeViewController.h
//  HypnoTime
//
//  Created by Bryan Irace on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentTimeViewController : UIViewController {
    IBOutlet UILabel *timeLabel;
}

- (IBAction)showCurrentTime:(id)sender;

@end
