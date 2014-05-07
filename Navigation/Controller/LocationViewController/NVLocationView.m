//
//  NVLocationView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVLocationView.h"
#import "IDPPropertyMacros.h"

#import "NVUser.h"

@implementation NVLocationView

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.latitude = nil;
    self.longitude = nil;
    self.address = nil;
    self.error = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setUser:(NVUser *)user {
    IDPNonatomicRetainPropertySynthesize(_user, user);
    
    CLLocationCoordinate2D coordinate = user.coordinate;
    self.latitude.text = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.longitude.text = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    self.address.text = user.address;
    self.error.text = user.error;
}

@end
