//
//  NVCompassControl.m
//  Compass
//
//  Created by Vitaliy Voronok on 5/4/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassControl.h"
#import "NVCompassImage.h"
#import "NVMath.h"

#import "IDPPropertyMacros.h"
#import "CGGeometry+IDPExtensions.h"

static const CGFloat kNVAnimationDuration   = 0.5;
static const CGSize  kNVShadowSize          = {10, 10};
static const CGFloat kNVShadowOpacity       = 0.7f;

static NSString * const kNVAnimationKeyPath = @"transform.rotation.z";
static NSString * const kNVAnimationKey     = @"rotationAnimation";

@interface NVCompassControl ()
@property (nonatomic, retain)	NVCompassImage  *compass;
@property (nonatomic, retain)	UIView          *shadow;

- (void)setup;

@end

@implementation NVCompassControl

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
	self.compass = nil;
	self.shadow = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setAngle:(CGFloat)angle {
	[self setAngle:angle animated:NO];
}

- (void)setAngle:(CGFloat)angle animated:(BOOL)animated {
	NSTimeInterval animationDuration = animated ? kNVAnimationDuration : 0;
	
	[UIView animateWithDuration:animationDuration animations:^{
		NVCompassImage *compass = self.compass;
		compass.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angle));
	} completion:^(BOOL finished) {
        IDPNonatomicAssignPropertySynthesize(_angle, angle);
    }];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

#pragma mark -
#pragma mark Public

- (void)setShadowWithSize:(CGSize)size opacity:(CGFloat)opacity {
	CALayer *layer = self.shadow.layer;
	
	layer.shadowColor = [UIColor blackColor].CGColor;
	layer.shadowOffset = size;
	layer.shadowOpacity = opacity;
    
	layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.compass.bounds].CGPath;
}

- (void)rotateViewWithDuration:(CFTimeInterval)duration byAngle:(CGFloat)angle {
    CGFloat radians = DEGREES_TO_RADIANS(angle);
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:kNVAnimationKeyPath];
    rotationAnimation.byValue = [NSNumber numberWithFloat:radians];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = YES;
    
    [CATransaction setCompletionBlock:^{
        self.angle += angle;
    }];
    
    [self.compass.layer addAnimation:rotationAnimation forKey:kNVAnimationKey];
    [CATransaction commit];
}

#pragma mark -
#pragma mark Private

- (void)setup {
    NVCompassImage *compass = [[[NVCompassImage alloc] initWithFrame:self.bounds] autorelease];
    self.compass = compass;
    
	UIView *shadow = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
	shadow.backgroundColor = [UIColor clearColor];
	[self addSubview:shadow];
	self.shadow = shadow;
    
    [self setShadowWithSize:kNVShadowSize opacity:kNVShadowOpacity];

	[self addSubview:compass];
}

@end
