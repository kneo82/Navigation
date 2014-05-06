//
//  NVMath.h
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

CLLocationCoordinate2D newCoordinateAtDistance (CLLocationCoordinate2D fromCoord,
                                                double distance,
                                                double bearingDegrees);

CGPoint pointForAngleOnEllipse (CGFloat angle, CGPoint center, CGFloat radius);

CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB);

CGFloat normalizeAngle (CGFloat angle);