//
//  NVGeocodingContext.m
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//



#import "NVGeocodingContext.h"
#import "NVUser.h"

#import "IDPPropertyMacros.h"

#import "NSObject+IDPExtensions.h"

static NSString * const kNVAddressKey = @"FormattedAddressLines";
static NSString * const kNVError = @"ERROR : %@";

@interface NVGeocodingContext ()
@property (nonatomic, retain)	CLGeocoder	*geocoder;

- (void)geocodeDidFinishedWithPlacemark:(CLPlacemark *)placemark error:(NSError *)error;
- (void)createGeocodingObject;

@end

@implementation NVGeocodingContext


#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
	self.user = nil;
	[self cancel];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setGeocoder:(CLGeocoder *)geocoder {
	if (geocoder != _geocoder) {
		[_geocoder cancelGeocode];
	}
	
	IDPNonatomicRetainPropertySynthesize(_geocoder, geocoder);
}

- (void)cancel {
	self.geocoder = nil;
	
	[super cancel];
}

#pragma mark -
#pragma mark Public

- (void)processingGeocoding {
    [self createGeocodingObject];
}

#pragma mark -
#pragma mark Private

- (void)createGeocodingObject {
	CLLocationCoordinate2D coordinate = self.user.coordinate;
	CLLocation *location = [[[CLLocation alloc] initWithLatitude:coordinate.latitude
													   longitude:coordinate.longitude] autorelease];
	
	CLGeocodeCompletionHandler completionHandler = ^(NSArray *placemarks, NSError *error) {
		[self geocodeDidFinishedWithPlacemark:[placemarks lastObject] error:error];
	};
	
	CLGeocoder *geocoder = [CLGeocoder object];
	[geocoder reverseGeocodeLocation:location completionHandler:completionHandler];
	self.geocoder = geocoder;
}

- (void)geocodeDidFinishedWithPlacemark:(CLPlacemark *)placemark error:(NSError *)error {
	self.geocoder = nil;
	
	if (nil != error) {
        self.user.error = [NSString stringWithFormat:kNVError, error];
		[self failLoading];
        
		return;
	}
    
    NSArray *addressLine = placemark.addressDictionary[kNVAddressKey];
    NSMutableString *formattedAddress = [NSMutableString string];
    for (NSString *item in addressLine) {
        [formattedAddress appendFormat:@"%@\n", item];
    }
    self.user.address = formattedAddress;
	
	[self finishLoading];
}

@end
