//
//  NVCompassViewController.m
//  Compass
//
//  Created by Vitaliy Voronok on 5/2/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NVCompassViewController.h"
#import "NVCompassView.h"
#import "NVCompassControl.h"

#import "CGGeometry+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"
#import "UIViewController+IDPExtensions.h"

static NSString * const kTitle = @"Compass";
static const CGFloat timeFullRotation = 2;
static const CGFloat maxTimeRotate = 5;

@interface NVCompassViewController ()
@property (nonatomic, retain)   CLLocationManager   *locationManager;
@property (nonatomic, readonly) NVCompassView       *compassView;

@property (nonatomic, retain)   NVRotationGestureRecognizer *gestureRecognizer;

- (void)setupLocationManager;
- (void)setupGestureRecognizer;

@end

@implementation NVCompassViewController

@dynamic compassView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.locationManager = nil;
    self.gestureRecognizer = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = kTitle;
    }
    
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocationManager];
    [self setupGestureRecognizer];
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVCompassView, compassView)

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    CGFloat mHeading = newHeading.magneticHeading;
    self.compassView.compass.angle = mHeading;
}

#pragma mark -
#pragma mark NVRotationGestureRecognizerDelegate

- (void) rotation: (CGFloat) angle {
    self.compassView.compass.angle = angle ;
}

- (void)endRotation:(CGFloat)angle {
    CGFloat duration = timeFullRotation * fabs(angle) / 360;
    duration = (maxTimeRotate > duration) ? duration : maxTimeRotate;
    [self.compassView.compass rotateViewWithDuration:duration byAngleInDegrees:-angle];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(duration);
        [self.locationManager startUpdatingHeading];
    });
}

- (void)gestureRecognizerStateFailed:(CGFloat)angle {
    [self endRotation:angle];
}

- (void)startRotation {
    [self.locationManager stopUpdatingHeading];
}

#pragma mark -
#pragma mark Private

- (void)setupLocationManager {
    self.locationManager = [CLLocationManager object];
    CLLocationManager *locationManager = self.locationManager;
    
    [locationManager setDelegate:self];
    
    [locationManager startUpdatingHeading];
}

- (void)setupGestureRecognizer {
    NVCompassView *compassView = self.compassView;
    CGRect rect = compassView.compass.bounds;
    CGPoint pointOfCentre = CGRectGetCenter(rect);
    CGFloat outRadius = rect.size.width / 2;
    
    self.gestureRecognizer = [[[NVRotationGestureRecognizer alloc]
                               initWithPointOfCentre:pointOfCentre
                               innerRadius:outRadius/5
                               outerRadius:outRadius
                               target:self]
                              autorelease];
    
    [compassView.compass addGestureRecognizer:self.gestureRecognizer];
}

@end
