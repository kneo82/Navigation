//
//  CGGeometry+NVExtensions.m
//  Navigation
//
//  Created by Vitaliy Voronok on 5/7/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "CGGeometry+NVExtensions.h"

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
