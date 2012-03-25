//
//  CountViewController.h
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountViewController : UIViewController {
    UITextField *numberField;
    UILabel *promptField;
    NSManagedObject *asset;
    NSManagedObject *location;
    NSNumber *count;
}

@property (nonatomic, retain) IBOutlet UITextField *numberField;
@property (nonatomic, retain) IBOutlet UILabel *promptField;
@property (nonatomic, retain) NSManagedObject *asset;
@property (nonatomic, retain) NSManagedObject *location;
@property (nonatomic, retain) NSNumber *count;

- (IBAction)update:(id)sender;
- (IBAction)cancel:(id)sender;

@end
