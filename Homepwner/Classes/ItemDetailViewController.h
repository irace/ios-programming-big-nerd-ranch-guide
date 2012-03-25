//
//  ItemDetailViewController.h
//  Homepwner
//
//  Created by Bryan Irace on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
@class Possession;

@interface ItemDetailViewController : UIViewController 
        <UINavigationControllerDelegate, UIImagePickerControllerDelegate, 
        UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate> {
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *serialNumberField;
    IBOutlet UITextField *valueField;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *inheritorNameField;
    IBOutlet UILabel *inheritorNumberField;
    Possession *possession;
}

@property (nonatomic, assign) Possession *possession;

- (void)takePicture:(id)sender;
- (IBAction)chooseInheritor:(id)sender;

@end
