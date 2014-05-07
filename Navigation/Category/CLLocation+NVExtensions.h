//
//  CLLocation+NVExtensions.h
//  Navigation
//
//  Created by Vitaliy Voronok on 5/7/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

CLLocationCoordinate2D newCoordinateAtDistance (CLLocationCoordinate2D fromCoord,
                                                double distance,
                                                double bearingDegrees);