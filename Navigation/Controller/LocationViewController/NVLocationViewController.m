//
//  NVLocationViewController.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NVLocationViewController.h"
#import "NVLocationView.h"
#import "NVUser.h"
#import "IDPModelObserver.h"
#import "NVLocationContext.h"
#import "IDPPropertyMacros.h"

#import "UIViewController+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"

static NSString * const kNVTitle = @"Location";
static NSString * const kNVError = @"ERROR : %@";
static NSString * const kNVErrorNotFindeLocation = @"Could not find location: %@";

static const CLLocationDistance kNVDistanceForFilter = 100;

@interface NVLocationViewController () <IDPModelObserver>
@property (nonatomic, readonly) NVLocationView      *locationView;
@property (nonatomic, retain)   NVLocationContext   *locationContext;

@end

@implementation NVLocationViewController

@dynamic locationView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.locationContext = nil;
    self.user = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = kNVTitle;
    }
    
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.locationContext) {
        self.locationContext = [NVLocationContext object];
    }
    
    NVLocationContext *context = self.locationContext;
    context.user = self.user;
    
    [context startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.locationContext startUpdatingLocation];
    
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVLocationView, locationView);

- (void)setLocationContext:(NVLocationContext *)locationContext {
    IDPNonatomicRetainPropertySynthesizeWithObserver(_locationContext, locationContext);
}

#pragma mark -
#pragma mark IDPModelObserver

- (void)modelDidLoad:(id)model {
    self.locationView.user = self.user;
}

- (void)modelDidFailToLoad:(id)model {
    self.locationView.user = self.user;
}

@end
