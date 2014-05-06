//
//  NVMath.m
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVMath.h"

static const double kNVEartRadiusInMeter = (6371.0 * 1000.0);

CLLocationCoordinate2D newCoordinateAtDistance (CLLocationCoordinate2D fromCoord,
                                                double distance,
                                                double bearingDegrees)
{
    double distanceRadians = distance / kNVEartRadiusInMeter;
    double bearingRadians = DEGREES_TO_RADIANS(bearingDegrees);
    double fromLatRadians = DEGREES_TO_RADIANS(fromCoord.latitude);
    double fromLonRadians = DEGREES_TO_RADIANS(fromCoord.longitude);
    
    double toLatRadians = asin(sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians));
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3 * M_PI), (2 * M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = RADIANS_TO_DEGREES(toLatRadians);
    result.longitude = RADIANS_TO_DEGREES(toLonRadians);
    
    return result;
}

CGPoint pointForAngleOnEllipse (CGFloat angle, CGPoint center, CGFloat radius) {
    CGFloat x = center.x + radius * cos(angle);
    CGFloat y = center.y + radius * sin(angle);
    
    return CGPointMake(x, y);
}

CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB)
{
    CGFloat a = endLineA.x - beginLineA.x;
    CGFloat b = endLineA.y - beginLineA.y;
    CGFloat c = endLineB.x - beginLineB.x;
    CGFloat d = endLineB.y - beginLineB.y;
    
    CGFloat atanA = atan2(a, b);
    CGFloat atanB = atan2(c, d);
    
    return (atanA - atanB) * 180 / M_PI;
}

CGFloat normalizeAngle (CGFloat angle) {
    if (180 < angle) {
        angle -= 360;
    } else if (-180 > angle) {
        angle += 360;
    }
    
    return angle;
}