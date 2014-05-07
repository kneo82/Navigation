//
//  NVHeadingContext.m
//  Navigation
//
//  Created by Vitaliy Voronok on 5/7/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "NVHeadingContext.h"
#import "IDPPropertyMacros.h"
#import "NVUser.h"

#import "NSObject+IDPExtensions.h"

@interface NVHeadingContext () <CLLocationManagerDelegate>
@property (nonatomic, retain)	CLLocationManager		*locationManager;

- (void)setupHeading;

@end

@implementation NVHeadingContext

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
	self.user = nil;
	[self cancel];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setLocationManager:(CLLocationManager *)locationManager {
	if (locationManager != _locationManager) {
		[_locationManager stopUpdatingHeading];
	}
	
	IDPNonatomicRetainPropertySynthesize(_locationManager, locationManager);
}

#pragma mark -
#pragma mark Public

- (void)cancel {
	self.locationManager = nil;
	
	[super cancel];
}

- (void)startUpdatingHeading {
    [self setupHeading];
}

- (void)stopUpdatingHeading {
    [self.locationManager stopUpdatingHeading];
}

#pragma mark -
#pragma mark Private

- (void)setupHeading {
	if (![CLLocationManager headingAvailable]) {
		[self failLoading];
		return;
	}
	
	CLLocationManager *locationManager = [CLLocationManager object];
	[locationManager startUpdatingHeading];
	self.locationManager = locationManager;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	self.user.heading = newHeading.magneticHeading;
	
	[self finishLoading];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {	
	[self failLoading];
}

@end
