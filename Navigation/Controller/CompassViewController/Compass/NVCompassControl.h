//
//  NVCompassControl.h
//  Compass
//
//  Created by Vitaliy Voronok on 5/4/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NVCompassImage;

@interface NVCompassControl : UIView 
@property (nonatomic, readonly)	NVCompassImage	*compass;
@property (nonatomic, readonly)	UIView			*shadow;
@property (nonatomic, assign)	CGFloat			angle;

- (void)setAngle:(CGFloat)angle animated:(BOOL)animated;
- (void)rotateViewWithDuration:(CFTimeInterval)duration byAngle:(CGFloat)angle;

@end
