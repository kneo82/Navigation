//
//  NVLocationView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVLocationView.h"
#import "IDPPropertyMacros.h"

static NSString * const kNVAddressKey = @"FormattedAddressLines";

@interface NVLocationView ()

- (void)fillPlacemark;

@end

@implementation NVLocationView

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.latitude = nil;
    self.longitude = nil;
    self.address = nil;
    self.error = nil;
    self.placemark = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setPlacemark:(CLPlacemark *)placemark {
    IDPNonatomicRetainPropertySynthesize(_placemark, placemark);
    [self fillPlacemark];
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    IDPNonatomicAssignPropertySynthesize(_coordinate, coordinate);
    
    self.latitude.text = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.longitude.text = [NSString stringWithFormat:@"%f", coordinate.longitude];
    self.error.text = nil;
}

#pragma mark -
#pragma mark Private

- (void)fillPlacemark {
    NSArray *addressLine = self.placemark.addressDictionary[kNVAddressKey];
    NSMutableString *formattedAddress = [NSMutableString string];
    for (NSString *item in addressLine) {
        [formattedAddress appendFormat:@"%@\n", item];
    }
    self.address.text = formattedAddress;
    self.error.text = nil;
}

@end
