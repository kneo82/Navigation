//
//  NVLocationContext.m
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVLocationContext.h"
#import "NVUser.h"
#import "NVGeocodingContext.h"

#import "IDPPropertyMacros.h"

@interface NVLocationContext () <CLLocationManagerDelegate, IDPModelObserver>
@property (nonatomic, retain)	CLLocationManager   *locationManager;
@property (nonatomic, retain)	NVGeocodingContext  *geocodingContext;

@end

@implementation NVLocationContext

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
		[_locationManager stopUpdatingLocation];
	}
	
	IDPNonatomicRetainPropertySynthesize(_locationManager, locationManager);
}

- (void)setGeocodingContext:(NVGeocodingContext *)geocodingContext {
	IDPNonatomicRetainPropertySynthesizeWithObserver(_geocodingContext, geocodingContext);
}

@end
