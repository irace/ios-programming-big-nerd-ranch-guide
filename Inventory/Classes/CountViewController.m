//
//  CountViewController.m
//  Inventory
//
//  Created by Bryan Irace on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CountViewController.h"

@implementation CountViewController

@synthesize numberField, promptField, asset, location, count;

#pragma mark -
#pragma mark Defined in NSObject

- (id)init {
    if (self = [super initWithNibName:@"CountViewController" 
                               bundle:nil]) {
        [[self navigationItem] setLeftBarButtonItem:
         [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                        target:self 
                                                        action:@selector(cancel:)] 
          autorelease]];
        
        [[self navigationItem] setRightBarButtonItem:
         [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                        target:self 
                                                        action:@selector(update:)] 
          autorelease]];
        
        [self setTitle:@"Update Count"];
    }
         
    return self;
}
 
- (void)dealloc {
    [numberField release];
    [promptField release];
    [location release];
    [count release];
    [asset release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Defined in UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *prompt = [NSString stringWithFormat:@"%@: %@",
                        [asset valueForKey:@"label"],
                        [location valueForKey:@"label"]];
    
    [promptField setText:prompt];
    [numberField setText:[count stringValue]];
    
    [numberField becomeFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self setNumberField:nil];
    [self setPromptField:nil];
}

#pragma mark -
#pragma mark Targeted by action selectors

- (void)update:(id)sender {
    [self setCount:[NSNumber numberWithInt:[[numberField text] intValue]]];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
    [self setCount:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
