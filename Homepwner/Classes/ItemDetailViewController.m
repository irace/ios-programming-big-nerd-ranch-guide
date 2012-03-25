//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Bryan Irace on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Possession.h"
#import "ImageCache.h"

@implementation ItemDetailViewController

@synthesize possession;

#pragma mark -
#pragma mark Defined in header

- (IBAction)chooseInheritor:(id)sender {
    // Allocate a people picker object
    ABPeoplePickerNavigationController *peoplePicker = 
            [[ABPeoplePickerNavigationController alloc] init];
    
    [peoplePicker setPeoplePickerDelegate:self];
    
    // Put that people picker on the screen
    [self presentModalViewController:peoplePicker animated:YES];
}

- (void)takePicture:(id)sender {
    [[self view] endEditing:YES];
    
    UIImagePickerController *imagePicker = 
            [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we just
    // pick from photo library
    
    if ([UIImagePickerController 
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // Image picker needs a delegate so we can respond to it's messages
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    [self presentModalViewController:imagePicker animated:YES];
    
    // The image picker will be retained by ItemDetailViewController until it 
    // has been dismissed
    [imagePicker release];
}

#pragma mark -
#pragma mark Defined in UIImagePickerControllerDelegate
               
- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // Use the unique ID as the possession's image key
    [possession setImageKey:(NSString *)uuidString];
    
    // We used "Create" in the functions to make objects, we need to release
    CFRelease(uuid);
    CFRelease(uuidString);
    
    // Store image in the image cache with the key
    [[ImageCache sharedImageCache] setImage:image forKey:[possession imageKey]];
    
    // Put that image onto the screen in our image view
    [imageView setImage:image];
    
    [possession setThumbnailFromImage:image];
    
    // Take the image picker off the screen - you must call this dismiss method
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Defined in UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [nameField setText:[possession possessionName]];
    [serialNumberField setText:[possession serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", 
                         [possession valueInDollars]]];

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] 
                                      autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateLabel setText:[dateFormatter stringFromDate:[possession dateCreated]]];
    
    NSString *imageKey = [possession imageKey];
    
    if (imageKey) {
        [imageView setImage:[[ImageCache sharedImageCache] 
                             imageForKey:imageKey]];
    } else {
        [imageView setImage:nil];
    }
    
    [[self navigationItem] setTitle:[possession possessionName]];
    [inheritorNameField setText:[possession inheritorName]];
    [inheritorNumberField setText:[possession inheritorNumber]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [nameField resignFirstResponder];
    [serialNumberField resignFirstResponder];
    [valueField resignFirstResponder];
    
    // "Save" changes to possession
    [possession setPossessionName:[nameField text]];
    [possession setSerialNumber:[serialNumberField text]];
    [possession setValueInDollars:[[valueField text] intValue]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [nameField release];
    nameField = nil;
    
    [serialNumberField release];
    serialNumberField = nil;
    
    [valueField release];
    valueField = nil;
    
    [dateLabel release];
    dateLabel = nil;
    
    [imageView release];
    imageView = nil;
}

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
    [super initWithNibName:@"ItemDetailViewController" bundle:nil];
    
    // Create a UIBarButtonItem with a camera icon, will send
    // takePicture: to our ItemDetailViewController when tapped
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] 
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemCamera 
                                            target:self 
                                            action:@selector(takePicture:)];
    
    // Place this image on our navigation bar when this viewcontroller
    // is on top of the navigation stack
    [[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
    
    // cameraBarButton is retained by the navigation item
    [cameraBarButtonItem release];
    return self;
}

- (void)dealloc {
    [nameField release];
    [serialNumberField release];
    [valueField release];
    [dateLabel release];
    [imageView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Defined in UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
#pragma mark Defined in ABPeoplePickerNavigationControllerDelegate

- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
       shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    // Get the first and last name from the selected person
    NSString *firstName = (NSString *)ABRecordCopyValue(person, 
                                                        kABPersonFirstNameProperty);
    
    NSString *lastName = (NSString *)ABRecordCopyValue(person, 
                                                        kABPersonLastNameProperty);
    
    // Get all of the phone numbers for this selected person
    ABMultiValueRef numbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    // Make sure we have at least one phone number for this person
    if (ABMultiValueGetCount(numbers) > 0) {
        // Grab the first phone number we see
        CFStringRef number = ABMultiValueCopyValueAtIndex(numbers, 0);
        
        // Add that phone number to the possession object we are editing
        [possession setInheritorNumber:(NSString *)number];
        
        // Set the on screen UILabel to this phone number
        [inheritorNumberField setText:(NSString *)number];
        
        // We used "Copy" to get this value, we need to manually release it
        CFRelease(number);
    }
    
    // Create a string with the first and last name together - full name
    // Ignore last or first name if it is null
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", 
                          firstName ? firstName : @"", 
                          lastName ? lastName : @""];
    
    [possession setInheritorName:fullName];
    
    // Manually release all copied objects
    [firstName release];
    [lastName release];
    CFRelease(numbers);

    // Update onscreen UILabel
    [inheritorNameField setText:fullName];
    
    // Get people picker off the screen
    [self dismissModalViewControllerAnimated:YES];
    
    // Do not perform default functionality (which is to go to detailed page)
    return NO;
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
       shouldContinueAfterSelectingPerson:(ABRecordRef)person 
                                 property:(ABPropertyID)property 
                               identifier:(ABMultiValueIdentifier)identifier {
    // ???: Do I need to implement this?
    return NO;
}

@end
