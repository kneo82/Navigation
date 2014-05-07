//
//  NVMapAnnotation.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/19/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVMapAnnotation.h"
#import "CLLocation+NVExtensions.h"

static NSString * const kNVDistance = @"Distance %.2f m";
@interface NVMapAnnotation ()

@end

@implementation NVMapAnnotation

#pragma mark -
#pragma mark Initializations and Deallocations

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    
	return self;
}

- (id)initWithDistance:(CLLocationDistance)distance
			   degrees:(CLLocationDegrees)degrees
		fromCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.coordinate = newCoordinateAtDistance(coordinate, distance, degrees);
        
        self.title = [NSString stringWithFormat:kNVDistance, distance];
    }
    
    return self;
}

@end
