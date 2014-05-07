//
//  NVViewController.m
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVTabBarController.h"

#import "NVMapViewController.h"
#import "NVLocationViewController.h"
#import "NVCompassViewController.h"
#import "NVUser.h"

#import "UIViewController+IDPInitialization.h"
#import "NSObject+IDPExtensions.h"

@interface NVTabBarController ()

- (void)createControllers;

@end

@implementation NVTabBarController

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self createControllers];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private

- (void)createControllers {
    NVMapViewController *mapController = nil;
    mapController = [NVMapViewController viewControllerWithDefaultNib];
    
    NVLocationViewController *locationController = nil;
    locationController = [NVLocationViewController viewControllerWithDefaultNib];
    
    NVCompassViewController *compassController = nil;
    compassController = [NVCompassViewController viewControllerWithDefaultNib];
    
    NSArray *controllers = [NSArray arrayWithObjects:mapController,
                            locationController,
                            compassController,
                            nil];
    
    self.viewControllers = controllers;
    
    NVUser *user = [NVUser object];
    [self.viewControllers makeObjectsPerformSelector:@selector(setUser:)
													  withObject:user];
}

@end
