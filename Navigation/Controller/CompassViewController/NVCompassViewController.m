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
#import "NVHeadingContext.h"
#import "IDPPropertyMacros.h"
#import "IDPModelObserver.h"
#import "NVUser.h"

#import "CGGeometry+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"
#import "UIViewController+IDPExtensions.h"
#import "UIAlertView+IDPExtensions.h"

static NSString * const kNVTitle            = @"Compass";
static NSString * const kNVErrorMessage     = @"Failed to retrieve user's heading";

static const CGFloat    kNVTimeFullRotation = 2;
static const CGFloat    kNVMaxTimeRotate    = 5;

@interface NVCompassViewController () <IDPModelObserver>
@property (nonatomic, retain)   NVHeadingContext    *headingContext;
@property (nonatomic, readonly) NVCompassView       *compassView;

@property (nonatomic, retain)   NVRotationGestureRecognizer *gestureRecognizer;

- (void)createGestureRecognizer;

@end

@implementation NVCompassViewController

@dynamic compassView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.headingContext = nil;
    self.gestureRecognizer = nil;
    self.user = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    
    [self createGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.headingContext) {
        self.headingContext = [NVHeadingContext object];
    }
    
    [self.headingContext startUpdatingHeading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.headingContext startUpdatingHeading];
    
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVCompassView, compassView)

- (void)setHeadingContext:(NVHeadingContext *)headingContext {
    IDPNonatomicRetainPropertySynthesizeWithObserver(_headingContext, headingContext);
}

#pragma mark -
#pragma mark Interface Handling

- (void)handleSwirlGesture:(NVRotationGestureRecognizer *)gestureRecognizer {
	CGFloat angle = gestureRecognizer.cumulatedAngle;
	UIGestureRecognizerState state = gestureRecognizer.state;
	
	if (UIGestureRecognizerStateEnded == state
        || UIGestureRecognizerStateCancelled == state
        || UIGestureRecognizerStateFailed == state)
    {
		CGFloat duration = kNVTimeFullRotation * fabs(angle) / 360;
        duration = (kNVMaxTimeRotate > duration) ? duration : kNVMaxTimeRotate;
        [self.compassView.compass rotateViewWithDuration:duration byAngle:-angle];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(duration);
            [self.headingContext startUpdatingHeading];
        });
	} else {
        [self.headingContext stopUpdatingHeading];
        
		self.compassView.compass.angle = angle;
	}
}

#pragma mark -
#pragma mark Private

- (void)createGestureRecognizer {
    NVCompassView *compassView = self.compassView;
    CGRect rect = compassView.compass.bounds;
    CGPoint centre = CGRectGetCenter(rect);
    CGFloat outRadius = rect.size.width / 2;
    
    self.gestureRecognizer = [NVRotationGestureRecognizer gestureWithCentre:centre
                                                                innerRadius:outRadius/5
                                                                outerRadius:outRadius];
    
    [self.gestureRecognizer addTarget:self action:@selector(handleSwirlGesture:)];
    
    [compassView.compass addGestureRecognizer:self.gestureRecognizer];
}

#pragma mark -
#pragma mark IDPModelObserver

- (void)modelDidLoad:(id)model {
    self.compassView.compass.angle = self.user.heading;
}

@end
