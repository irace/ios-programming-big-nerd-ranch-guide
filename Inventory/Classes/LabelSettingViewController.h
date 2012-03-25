//
//  LabelSettingViewController.h
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelSettingViewController : UIViewController {
    UITextField *textField;
    NSString *value;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, copy) NSString *value;

- (IBAction)cancel:(id)sender;
- (IBAction)create:(id)sender;

@end
