//
//  MKAnnotationView+NVExtensions.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/19/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (NVExtensions)

- (id)dequeuePin:(Class)theClass  withAnnotation:(id<MKAnnotation>)annotation;

@end
