//
//  NVCompassControl.m
//  Compass
//
//  Created by Vitaliy Voronok on 5/4/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassControl.h"
#import "NVCompassImage.h"

#import "IDPPropertyMacros.h"
#import "CGGeometry+IDPExtensions.h"

static const CGFloat kAnimationDuration = 0.5;
static const CGSize kShadowSize	 = {10, 10};
static const CGFloat kShadowOpacity = 0.7f;

@interface NVCompassControl ()
@property (nonatomic, retain)	NVCompassImage  *compass;
@property (nonatomic, retain)	UIView          *shadow;

- (void)setup;
- (CGFloat)radiansFromDegrees:(CGFloat)degrees;

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
	NSTimeInterval animationDuration = animated ? kAnimationDuration : 0;
	
	[UIView animateWithDuration:animationDuration animations:^{
		NVCompassImage *compass = self.compass;
		compass.transform = CGAffineTransformMakeRotation([self radiansFromDegrees:angle]);
		
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

- (void)rotateViewWithDuration:(CFTimeInterval)duration byAngleInDegrees:(CGFloat)angleInDegrees {
    CGFloat angleInRadians = [self radiansFromDegrees:angleInDegrees];
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:angleInRadians];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = YES;
    
    [CATransaction setCompletionBlock:^{
        self.angle += angleInDegrees;
    }];
    
    [self.compass.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
    
    [self setShadowWithSize:kShadowSize opacity:kShadowOpacity];

	[self addSubview:compass];
}

- (CGFloat)radiansFromDegrees:(CGFloat)degrees {
    return degrees * (M_PI / 180.0);
}

@end
