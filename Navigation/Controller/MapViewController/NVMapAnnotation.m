//
//  NVMapAnnotation.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/19/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVMapAnnotation.h"

static const double kNVEartRadiusInMeter = (6371.0 * 1000.0);

@interface NVMapAnnotation ()

- (double)radiansFromDegrees:(double)degrees;
- (double)degreesFromRadians:(double)radians;
- (CLLocationCoordinate2D)coordinateFromCoord:(CLLocationCoordinate2D)fromCoord
                                   atDistance:(double)distance
                             atBearingDegrees:(double)bearingDegrees;

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
        self.coordinate = [self coordinateFromCoord:coordinate
                                       atDistance:distance
                                   atBearingDegrees:degrees];
        
        self.title = [NSString stringWithFormat:@"Distance %.2f m", distance];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private

- (double)radiansFromDegrees:(double)degrees {
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians {
    return radians * (180.0/M_PI);
}

- (CLLocationCoordinate2D)coordinateFromCoord:(CLLocationCoordinate2D)fromCoord
                                 atDistance:(double)distance
                             atBearingDegrees:(double)bearingDegrees
{
    double distanceRadians = distance / kNVEartRadiusInMeter;
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin(sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians));
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3 * M_PI), (2 * M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    
    return result;
}

@end
