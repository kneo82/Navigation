//
//  NVRotationGestureRecognizer.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/28/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface NVRotationGestureRecognizer : UIGestureRecognizer
@property (nonatomic, assign)   CGFloat cumulatedAngle;

+ (id)gestureWithCentre:(CGPoint)centre
            innerRadius:(CGFloat)innerRadius
            outerRadius:(CGFloat)outerRadius;

- (id)initWithCentre:(CGPoint)centre
                innerRadius:(CGFloat)innerRadius
                outerRadius:(CGFloat)outerRadius;

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
