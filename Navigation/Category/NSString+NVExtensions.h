//
//  NSString+NVExtensions.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/23/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NVExtensions)

-(void)drawWithBasePoint:(CGPoint)basePoint
                andAngle:(CGFloat)angle
                 andFont:(UIFont *)font;

@end
