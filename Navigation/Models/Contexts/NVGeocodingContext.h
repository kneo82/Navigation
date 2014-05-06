//
//  NVGeocodingContext.h
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IDPModel.h"

@class  NVUser;

@interface NVGeocodingContext : IDPModel
@property (nonatomic, retain)   NVUser *user;

@end
