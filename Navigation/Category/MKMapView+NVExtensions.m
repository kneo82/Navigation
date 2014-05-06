//
//  MKAnnotationView+NVExtensions.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/19/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "MKMapView+NVExtensions.h"

@implementation MKMapView (NVExtensions)

- (id)dequeuePin:(Class)theClass  withAnnotation:(id<MKAnnotation>)annotation {
    NSString *reuseIdentifier = NSStringFromClass(theClass);
 
    MKAnnotationView *pin = [self dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if (!pin) {
        return [[[theClass alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    pin.annotation = annotation;
    
    return pin;
}

@end