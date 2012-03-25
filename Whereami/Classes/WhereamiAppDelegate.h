//
//  WhereamiAppDelegate.h
//  Whereami
//
//  Created by Bryan Irace on 10/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereamiAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
    UIWindow *window;
	
	CLLocationManager *locationManager;
	
	IBOutlet MKMapView *mapView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UITextField *locationTitleField;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)findLocation;
- (void)foundLocation;

@end

