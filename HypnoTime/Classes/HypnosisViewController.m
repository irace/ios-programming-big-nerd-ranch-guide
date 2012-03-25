    //
//  HypnosisViewController.m
//  HypnoTime
//
//  Created by Bryan Irace on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@implementation HypnosisViewController

- (id)init {
	// Call the superclass's designated initializer
	[super initWithNibName:nil 
					bundle:nil];
	
	// Get the tab bar item
	UITabBarItem *tabBarItem = [self tabBarItem];
	
	// Give it a label
	[tabBarItem setTitle:@"Hypnosis"];
	
    UIImage *image = [UIImage imageNamed:@"Hypno.png"];
    [tabBarItem setImage:image];
    
	return self;
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	return [self init];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    HypnosisView *hv = (HypnosisView *)[self view];
    [hv setXShift:10.0 * [acceleration x]];
    [hv setYShift:-10.0 * [acceleration y]];
    [hv setNeedsDisplay];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    HypnosisView *hypnosisView = [[HypnosisView alloc] init];
    [hypnosisView setBackgroundColor:[UIColor whiteColor]];
    
    [self setView:hypnosisView];
    [hypnosisView release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Monitoring accelerometer");
    UIAccelerometer *a = [UIAccelerometer sharedAccelerometer];

    // Receive updates every 1/10th of a second
    [a setUpdateInterval:0.1];
    [a setDelegate:self];
    
    [[self view] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
