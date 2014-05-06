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

#import "UIViewController+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"

static NSString * const kNVTitle = @"Location";
static NSString * const kNVError = @"ERROR : %@";
static NSString * const kNVErrorNotFindeLocation = @"Could not find location: %@";

static const CLLocationDistance kNVDistanceForFilter = 100;

@interface NVLocationViewController ()
@property (nonatomic, readonly) NVLocationView      *locationView;
@property (nonatomic, retain)   CLLocationManager   *locationManager;

- (void)setupLocationManager;

@end

@implementation NVLocationViewController

@dynamic locationView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.locationManager = nil;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocationManager];
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVLocationView, locationView)

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NVLocationView *locationView = self.locationView;
    CLGeocoder *coder = [CLGeocoder object];
    
    locationView.coordinate = coordinate;
    
    [coder reverseGeocodeLocation:location
                completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (!error) {
            locationView.placemark = [placemarks firstObject];
        } else {
            locationView.error.text = [NSString stringWithFormat:kNVError, error];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSString *errorString = [NSString stringWithFormat:kNVErrorNotFindeLocation, error];
    self.locationView.error.text = errorString;
}

#pragma mark -
#pragma mark Private

- (void)setupLocationManager {
    self.locationManager = [CLLocationManager object];
    CLLocationManager *locationManager = self.locationManager;
    
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.distanceFilter = kNVDistanceForFilter;
    
    [locationManager startUpdatingLocation];
}

@end
