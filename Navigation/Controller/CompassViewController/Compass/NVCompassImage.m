//
//  NVCompass.m
//  Compass
//
//  Created by Vitaliy Voronok on 5/2/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassImage.h"

#import "IDPPropertyMacros.h"

#import "CGGeometry+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat margin = 4.0;
static const CGFloat thicksMainLine = 6.0;
static const CGFloat fontSize = 16.0;
static const CGFloat angleSegments = 6.0;
static const CGFloat angleBigSegments = 30.0;
static const CGFloat lenghtShortDivision = 15.0;
static const CGFloat radiusCentralEllipce = 3.0;

static NSString * const kNVDirections[]	 = {@"N", @"E", @"S", @"W"};
static const CGFloat	kNVDirectionAngles[] = {270.0f, 0.0f, 90.0f, 180.0f};
static const NSUInteger kNVDirectionCount	 =	sizeof(kNVDirections) / sizeof(NSString *);

@interface NVCompassImage ()

- (CGFloat)radiansFromDegrees:(CGFloat)degrees;

- (CGPoint)pointForAngle:(CGFloat)angle
         centerCoordinat:(CGPoint)centerCoordinat
                  radius:(CGFloat)radius;

- (void)drawSegmentLineWithCenterCoordinat:(CGPoint)centerCoordinat
                                    radius:(CGFloat)radius
                            angleInRadians:(CGFloat)radians
                                lenghtLine:(CGFloat)lenght;

- (void)drawDirectionWithCenterCoordinat:(CGPoint)centerCoordinat radiusCircle:(CGFloat)radius;

- (void)drawDivisionCompassWithCenterCoordinat:(CGPoint)centerCoordinat
                                        radius:(CGFloat)radius;

- (void)drawCompassEllipseWithCenterCoordinat:(CGPoint)centerCoordinat radius:(CGFloat)radius;

@end

@implementation NVCompassImage

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width - 2 * margin;
    
    CGPoint centerCoordinat = CGRectGetCenter (rect);
    CGFloat radius = width / 2;
    
    [self drawCompassEllipseWithCenterCoordinat:centerCoordinat radius:radius];

    [self drawDivisionCompassWithCenterCoordinat:centerCoordinat radius:radius];
    
    [self drawDirectionWithCenterCoordinat:centerCoordinat radiusCircle:radius];
}

#pragma mark -
#pragma mark Private

- (CGFloat)radiansFromDegrees:(CGFloat)degrees {
    return degrees * (M_PI/180.0);
}

- (CGPoint)pointForAngle:(CGFloat)angle
         centerCoordinat:(CGPoint)centerCoordinat
                  radius:(CGFloat)radius
{
    CGFloat x = centerCoordinat.x + radius * cos(angle);
    CGFloat y = centerCoordinat.y + radius * sin(angle);
    
    return CGPointMake(x, y);
}

- (void)drawSegmentLineWithCenterCoordinat:(CGPoint)centerCoordinat
                          radius:(CGFloat)radius
                  angleInRadians:(CGFloat)radians
                      lenghtLine:(CGFloat)lenght
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGPoint point1 = [self pointForAngle:radians centerCoordinat:centerCoordinat radius:radius];
    
    CGFloat radius2 = radius - lenght;
    CGPoint point2 = [self pointForAngle:radians centerCoordinat:centerCoordinat radius:radius2];
    
    [[UIColor blackColor] setStroke];
    if (radians <= -M_PI_2) {
        [[UIColor redColor] setStroke];
    }
    
    CGPoint p[] = {point1,point2};
    CGContextStrokeLineSegments(context, p, 2);
    
    CGContextRestoreGState(context);
}

- (void)drawDirectionWithCenterCoordinat:(CGPoint)centerCoordinat radiusCircle:(CGFloat)radius {
    CGFloat radiusFontPosition = radius - lenghtShortDivision * 2 - fontSize;
    
    for (NSUInteger index = 0; index < kNVDirectionCount; index++) {
		UILabel *directionLabel = [UILabel object];
		directionLabel.text = kNVDirections[index];
		[directionLabel sizeToFit];
		
        CGFloat radians = [self radiansFromDegrees:kNVDirectionAngles[index]];
		
		directionLabel.transform = CGAffineTransformMakeRotation(radians + M_PI_2);
		
        CGPoint coordinateDrawText = [self pointForAngle:radians
                                         centerCoordinat:centerCoordinat
                                                  radius:radiusFontPosition];
        
        directionLabel.center = coordinateDrawText;
		[self addSubview:directionLabel];
	}
}

- (void)drawDivisionCompassWithCenterCoordinat:(CGPoint)centerCoordinat
                                        radius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, thicksMainLine / 2.0);
    
    for (int i = 0; i < 360 / angleSegments; i++) {
        NSUInteger countShortDivisionInLong = angleBigSegments / angleSegments;
        CGFloat lenght = i % countShortDivisionInLong ? lenghtShortDivision : 2 * lenghtShortDivision;
        CGFloat radians = [self radiansFromDegrees:((angleSegments * i) - 90)];

        [self drawSegmentLineWithCenterCoordinat:centerCoordinat
                                          radius:radius
                                  angleInRadians:radians
                                      lenghtLine:lenght ];
    }
    
    CGContextRestoreGState(context);
}

- (void)drawCompassEllipseWithCenterCoordinat:(CGPoint)centerCoordinat radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, thicksMainLine);
    
    CGPoint startPoint = CGPointMake (centerCoordinat.x - radius, centerCoordinat.y - radius);
    CGFloat width = radius * 2;
    CGRect circleRect = CGRectMake(startPoint.x, startPoint.y, width, width);

    [[UIColor whiteColor] set];
    [[UIColor blackColor] setStroke];
    CGContextFillEllipseInRect(context, circleRect);
    CGContextStrokeEllipseInRect(context, circleRect);
    
    CGRect ellipseRect = CGRectMake (centerCoordinat.x - radiusCentralEllipce / 2,
                                     centerCoordinat.y - radiusCentralEllipce / 2,
                                     radiusCentralEllipce,
                                     radiusCentralEllipce);
    
    CGContextStrokeEllipseInRect(context, ellipseRect);
    
    CGContextRestoreGState(context);
}

@end
