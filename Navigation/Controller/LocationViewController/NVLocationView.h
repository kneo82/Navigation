//
//  NVLocationView.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class NVUser;

@interface NVLocationView : UIView
@property (nonatomic, retain)   IBOutlet UILabel        *latitude;
@property (nonatomic, retain)   IBOutlet UILabel        *longitude;
@property (nonatomic, retain)   IBOutlet UILabel        *address;
@property (nonatomic, retain)   IBOutlet UILabel        *error;
@property (nonatomic, retain)   NVUser                  *user;

@end
