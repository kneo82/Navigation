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

#import "NSObject+IDPExtensions.h"

static NSString * const kNVTitle = @"Location";
static NSString * const kNVError = @"ERROR : %@";
static NSString * const kNVErrorNotFindeLocation = @"Could not find location: %@";
static NSString * const kNVErrorServicesUnavailable = @"Location Services Unavailable";

static const CLLocationDistance kNVDistanceForFilter = 100;

@interface NVLocationContext () <CLLocationManagerDelegate, IDPModelObserver>
@property (nonatomic, retain)	CLLocationManager   *locationManager;
@property (nonatomic, retain)	NVGeocodingContext  *geocodingContext;

- (void)createLocatiomManager;

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

#pragma mark -
#pragma mark Public

- (void)startUpdatingLocation {
    [self createLocatiomManager];
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
    self.geocodingContext = nil;
}

- (void)cancel {
	self.locationManager = nil;
	self.geocodingContext = nil;
	
	[super cancel];
}

#pragma mark -
#pragma mark Private

- (void)createLocatiomManager {
    if (![CLLocationManager locationServicesEnabled]) {
        self.user.error = kNVErrorServicesUnavailable;
		[self failLoading];
        
		return;
	}
    
    if (!self.locationManager) {
        self.locationManager = [CLLocationManager object];
    }
    
    CLLocationManager *locationManager = self.locationManager;
    
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = kNVDistanceForFilter;
    
    [locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NVUser *user = self.user;
    
    user.coordinate = coordinate;
    
    if (!self.geocodingContext) {
        self.geocodingContext = [NVGeocodingContext object];
    }
    
    NVGeocodingContext *geocoding = self.geocodingContext;
    geocoding.user = self.user;
    
    [geocoding processingGeocoding];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorString = [NSString stringWithFormat:kNVErrorNotFindeLocation, error];
    self.user.error = errorString;
    
	[self failLoading];
}

#pragma mark -
#pragma mark IDPModelObserver

- (void)modelDidLoad:(id)model {
	self.geocodingContext = nil;
	
	[self finishLoading];
}

- (void)modelDidFailToLoad:(id)model {
	self.geocodingContext = nil;
	
	[self failLoading];
}

@end
