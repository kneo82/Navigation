//
//  NVMapViewController.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class  NVUser;

@interface NVMapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, retain)   NVUser *user;

@end
