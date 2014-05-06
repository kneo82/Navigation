//
//  NVUser.h
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NVUser : NSObject
@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString				*country;
@property (nonatomic, copy)		NSString				*region;
@property (nonatomic, copy)		NSString				*city;
@property (nonatomic, copy)		NSString				*street;
@property (nonatomic, copy)		NSString				*postalCode;

@property (nonatomic, readonly)	NSArray					*annotations;
@property (nonatomic, assign)	CLLocationDirection		heading;

- (void)createAnnotations;

@end
