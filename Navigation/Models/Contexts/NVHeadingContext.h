//
//  NVHeadingContext.h
//  Navigation
//
//  Created by Vitaliy Voronok on 5/7/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IDPModel.h"

@class  NVUser;

@interface NVHeadingContext : IDPModel
@property (nonatomic, retain)   NVUser	*user;

- (void)startUpdatingHeading;
- (void)stopUpdatingHeading;

@end
