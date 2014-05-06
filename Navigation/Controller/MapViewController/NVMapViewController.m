//
//  NVMapViewController.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVMapViewController.h"
#import "NVMapView.h"
#import "NVMapAnnotation.h"
#import "NVPinView.h"

#import "UIViewController+IDPExtensions.h"
#import "MKMapView+NVExtensions.h"
#import "UIAlertView+IDPExtensions.h"

static NSString * const kNVTitle = @"Map";

static const CLLocationDegrees kNVNorth   = 0.0;
static const CLLocationDegrees kNVSouth   = 180.0;
static const CLLocationDegrees kNVWest    = -90.0;
static const CLLocationDegrees kNVEast    = 90.0;

static NSString * const kLocationError = @"Unable to determine the  location";

#define kDistanceArray [NSArray arrayWithObjects:@100, @500, @1000, @2000, nil]

@interface NVMapViewController ()
@property (nonatomic, readonly) NVMapView *mapView;

@end

@implementation NVMapViewController

@dynamic mapView;

#pragma mark -
#pragma mark Initializations and Deallocations

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
    
    MKMapView *map = self.mapView.map;
    CLLocationCoordinate2D coordinate = map.userLocation.location.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    
    [map setRegion:region animated:YES];
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVMapView, mapView)

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)        mapView:(MKMapView *)mapView
  didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D userCoordinate = userLocation.coordinate;

    [mapView setCenterCoordinate:userCoordinate animated:YES];
    [mapView removeAnnotations:mapView.annotations];
    
    NSArray *distances = kDistanceArray;
    
    for (NSNumber *distance  in distances) {
        NVMapAnnotation *placemark = nil;
        placemark = [[[NVMapAnnotation alloc] initWithDistance:distance.doubleValue
                                                       degrees:kNVWest
                                                fromCoordinate:userCoordinate]autorelease];

        [mapView addAnnotation:placemark];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *reusable = nil;
    reusable = [mapView dequeuePin:[NVPinView class]];
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)reusable;
    
    if (!pinView) {
        return [[[NVPinView alloc] initWithAnnotation:annotation] autorelease];
    }
    
    pinView.annotation = annotation;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
	[UIAlertView showErrorWithMessage:kLocationError];
}

@end
