//
//  LabelSettingViewController.m
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LabelSettingViewController.h"

@implementation LabelSettingViewController

@synthesize textField, value;

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
    if (self = [super initWithNibName:@"LabelSettingViewController" bundle:nil]) {
        [self setTitle:@"New Record"];
        
        [[self navigationItem] setRightBarButtonItem:
         [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                        target:self                                  
                                                        action:@selector(create:)] autorelease]];
        
        [[self navigationItem] setLeftBarButtonItem:
         [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel                         
                                                        target:self                                  
                                                        action:@selector(cancel:)] autorelease]];
    }
    
    return self;
}

- (void)dealloc {
    [textField release];
    [value release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Defined in header

- (IBAction)create:(id)sender {
    [self setValue:[textField text]];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [self setValue:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Defined in UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self setTextField:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [textField becomeFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
    
}

@end
