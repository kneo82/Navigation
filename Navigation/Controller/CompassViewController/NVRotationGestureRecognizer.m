//
//  NVRotationGestureRecognizer.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/28/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVRotationGestureRecognizer.h"

#import "CGGeometry+IDPExtensions.h"
#import "CGGeometry+NVExtensions.h"

@interface NVRotationGestureRecognizer ()
@property (nonatomic, assign)   CGPoint centre;
@property (nonatomic, assign)   CGFloat innerRadius;
@property (nonatomic, assign)   CGFloat outerRadius;

@end

@implementation NVRotationGestureRecognizer

#pragma mark -
#pragma mark Class Methods

+ (id)gestureWithCentre:(CGPoint)centre
            innerRadius:(CGFloat)innerRadius
            outerRadius:(CGFloat)outerRadius
{
    return [[[self alloc] initWithCentre:centre innerRadius:innerRadius outerRadius:outerRadius] autorelease];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    [super dealloc];
}

- (id)initWithCentre:(CGPoint)centre
                innerRadius:(CGFloat)innerRadius
                outerRadius:(CGFloat)outerRadius
{
    self = [super init];
    
    if (self) {
        self.innerRadius = innerRadius;
        self.outerRadius = outerRadius;
        self.centre = centre;
    }
    
    return  self;
}

#pragma mark -
#pragma mark UIGestureRecognizer

- (void)reset {
    [super reset];
    
    self.cumulatedAngle = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (1 != [touches count]) {
        self.state = UIGestureRecognizerStateFailed;
        
        return;
    }
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (UIGestureRecognizerStateFailed == self.state) {
        return;
    }
    
    CGPoint nowPoint  = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    CGPoint pointOfCentre = self.centre;
    
    CGFloat distance = CGDistance(self.centre, nowPoint);
    if (self.innerRadius <= distance && distance <= self.outerRadius) {
        CGFloat angle = angleBetweenLinesInDegrees(pointOfCentre, prevPoint, pointOfCentre, nowPoint);
        
        angle = normalizeAngle(angle);
        
        self.cumulatedAngle += angle;
        self.state = UIGestureRecognizerStateChanged;
        
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UIGestureRecognizerState state = self.state;
    if (UIGestureRecognizerStatePossible == state
        || UIGestureRecognizerStateChanged == state)
    {
        self.state = UIGestureRecognizerStateEnded;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateCancelled;
}

@end
