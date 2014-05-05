//
//  NSString+NVExtensions.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/23/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NSString+NVExtensions.h"
#import "CGGeometry+IDPExtensions.h"

@implementation NSString (NVExtensions)

-(void)  drawWithBasePoint:(CGPoint)basePoint
                  andAngle:(CGFloat)angle
                   andFont:(UIFont *)font
{
    CGSize textSize = [self sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font.pointSize]}];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGAffineTransform translation = CGAffineTransformMakeTranslation(basePoint.x, basePoint.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    
    CGContextConcatCTM(context, translation);
    CGContextConcatCTM(context, rotation);
    
    NSDictionary *textAtributs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGPoint point = CGPointMake(-1 * textSize.width / 2, -1 * textSize.height / 2);
    [self drawAtPoint:point withAttributes:textAtributs];

    CGContextRestoreGState(context);
}

@end
