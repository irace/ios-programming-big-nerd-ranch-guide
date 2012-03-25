//
//  WhereamiAppDelegate.m
//  Whereami
//
//  Created by Bryan Irace on 10/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "WhereamiAppDelegate.h"
#import "MapPoint.h"

@implementation WhereamiAppDelegate

@synthesize window;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation {
	NSLog(@"%@", newLocation);
	
	NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
	
	if (t < -180) {
		// This is cached data, you don't want it, keep looking
		return;
	}
	
	MapPoint *mp = [[MapPoint alloc] initWithCoordinate:[newLocation coordinate]
												  title:[locationTitleField text]];
	[mapView addAnnotation:mp];
	[mp release];
	
	[self foundLocation];
	
}

- (void)locationManager:(CLLocationManager *)manager 
	   didFailWithError:(NSError *)error {
	NSLog(@"Could not find location: @%", error);
	
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 250, 250);
	[mv setRegion:region animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
	[self findLocation];
	[tf resignFirstResponder];

	return YES;
}

- (void)findLocation {
	[locationManager startUpdatingLocation];
	[activityIndicator startAnimating];
	[locationTitleField setHidden:YES];
}

- (void)foundLocation {
	[locationTitleField setText:@""];
	[activityIndicator stopAnimating];
	[locationTitleField setHidden:NO];
	[locationManager stopUpdatingLocation];
}

- (BOOL)application:(UIApplication *)application 
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	locationManager = [[CLLocationManager alloc] init];	
	[locationManager setDelegate:self];
	
	[locationManager setDistanceFilter:kCLDistanceFilterNone];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	
	//[locationManager startUpdatingLocation];
	[mapView setShowsUserLocation:YES];
	
	[window makeKeyAndVisible];
	return YES;
	
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[locationManager setDelegate:nil];
    [super dealloc];
}


@end
