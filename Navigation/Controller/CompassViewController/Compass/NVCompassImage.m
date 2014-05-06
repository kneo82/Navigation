//
//  NVCompass.m
//  Compass
//
//  Created by Vitaliy Voronok on 5/2/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassImage.h"

#import "NVMath.h"
#import "IDPPropertyMacros.h"

#import "CGGeometry+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kNVMargin                  = 4.0;
static const CGFloat kNVThicksMainLine          = 6.0;
static const CGFloat kNVFontSize                = 16.0;
static const CGFloat kNVAngleSegments           = 6.0;
static const CGFloat kNVAngleBigSegments        = 30.0;
static const CGFloat kNVLenghtShortDivision     = 15.0;
static const CGFloat kNVRadiusCentralEllipce    = 3.0;

static NSString * const kNVDirections[]         = {@"N", @"E", @"S", @"W"};
static const CGFloat	kNVDirectionAngles[]    = {270.0f, 0.0f, 90.0f, 180.0f};
static const NSUInteger kNVDirectionCount       = sizeof(kNVDirections) / sizeof(NSString *);

@interface NVCompassImage ()

- (void)drawSegmentLineWithCenter:(CGPoint)center
                           radius:(CGFloat)radius
                            angle:(CGFloat)radians
                           lenght:(CGFloat)lenght;

- (void)drawDirectionWithCenter:(CGPoint)center radius:(CGFloat)radius;

- (void)drawDivisionCompassWithCenter:(CGPoint)center radius:(CGFloat)radius;

- (void)drawCompassEllipseWithCenter:(CGPoint)center radius:(CGFloat)radius;

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
    CGFloat width = rect.size.width - 2 * kNVMargin;
    
    CGPoint center = CGRectGetCenter (rect);
    CGFloat radius = width / 2;
    
    [self drawCompassEllipseWithCenter:center radius:radius];

    [self drawDivisionCompassWithCenter:center radius:radius];
    
    [self drawDirectionWithCenter:center radius:radius];
}

#pragma mark -
#pragma mark Private

- (void)drawSegmentLineWithCenter:(CGPoint)center
                           radius:(CGFloat)radius
                            angle:(CGFloat)radians
                           lenght:(CGFloat)lenght;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGPoint point1 = pointForAngleOnEllipse (radians, center, radius);
    
    CGFloat radius2 = radius - lenght;
    CGPoint point2 = pointForAngleOnEllipse (radians, center, radius2);
    
    [[UIColor blackColor] setStroke];
    if (radians <= -M_PI_2) {
        [[UIColor redColor] setStroke];
    }
    
    CGPoint p[] = {point1,point2};
    CGContextStrokeLineSegments(context, p, 2);
    
    CGContextRestoreGState(context);
}

- (void)drawDirectionWithCenter:(CGPoint)center radius:(CGFloat)radius {
    CGFloat radiusFontPosition = radius - kNVLenghtShortDivision * 2 - kNVFontSize;
    
    for (NSUInteger index = 0; index < kNVDirectionCount; index++) {
		UILabel *directionLabel = [UILabel object];
		directionLabel.text = kNVDirections[index];
		[directionLabel sizeToFit];
		
        CGFloat radians = DEGREES_TO_RADIANS(kNVDirectionAngles[index]);
		
		directionLabel.transform = CGAffineTransformMakeRotation(radians + M_PI_2);
		
        CGPoint coordinateDrawText = pointForAngleOnEllipse(radians, center, radiusFontPosition);
        directionLabel.center = coordinateDrawText;
		[self addSubview:directionLabel];
	}
}

- (void)drawDivisionCompassWithCenter:(CGPoint)center radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, kNVThicksMainLine / 2.0);
    
    for (int i = 0; i < 360 / kNVAngleSegments; i++) {
        NSUInteger countShortDivisionInLong = kNVAngleBigSegments / kNVAngleSegments;
        CGFloat lenght = i % countShortDivisionInLong ? kNVLenghtShortDivision : 2 * kNVLenghtShortDivision;
        CGFloat radians = DEGREES_TO_RADIANS((kNVAngleSegments * i) - 90);

        [self drawSegmentLineWithCenter:center radius:radius angle:radians lenght:lenght];
    }
    
    CGContextRestoreGState(context);
}

- (void)drawCompassEllipseWithCenter:(CGPoint)center radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, kNVThicksMainLine);
    
    CGPoint startPoint = CGPointMake (center.x - radius, center.y - radius);
    CGFloat width = radius * 2;
    CGRect circleRect = CGRectMake(startPoint.x, startPoint.y, width, width);

    [[UIColor whiteColor] set];
    [[UIColor blackColor] setStroke];
    CGContextFillEllipseInRect(context, circleRect);
    CGContextStrokeEllipseInRect(context, circleRect);
    
    CGRect ellipseRect = CGRectMake (center.x - kNVRadiusCentralEllipce / 2,
                                     center.y - kNVRadiusCentralEllipce / 2,
                                     kNVRadiusCentralEllipce,
                                     kNVRadiusCentralEllipce);
    
    CGContextStrokeEllipseInRect(context, ellipseRect);
    
    CGContextRestoreGState(context);
}

@end
