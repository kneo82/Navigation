//
//  NVUser.m
//  Navigation
//
//  Created by Vitaliy Voronok on 5/6/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVUser.h"
#import "NVMapAnnotation.h"

static const CLLocationDegrees kNVNorth   = 0.0;
static const CLLocationDegrees kNVSouth   = 180.0;
static const CLLocationDegrees kNVWest    = -90.0;
static const CLLocationDegrees kNVEast    = 90.0;

#define kDistanceArray [NSArray arrayWithObjects:@100, @500, @1000, @2000, nil]

@interface NVUser ()
@property (nonatomic, retain)	NSMutableArray	*mutableAnnotations;

@end

@implementation NVUser

@dynamic annotations;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
	self.country = nil;
	self.region = nil;
	self.city = nil;
	self.street = nil;
	self.postalCode = nil;
	
	self.mutableAnnotations = nil;
	
	[super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.mutableAnnotations = [NSMutableArray array];
    }
	
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSArray *)annotations {
	return [[self.mutableAnnotations copy] autorelease];
}

#pragma mark -
#pragma mark Public

- (void)createAnnotations {
	NSMutableArray *annotations = self.mutableAnnotations;
	[annotations removeAllObjects];
    
    NSArray *distances = kDistanceArray;
    
    for (NSNumber *distance  in distances) {
        NVMapAnnotation *placemark = nil;
        placemark = [[[NVMapAnnotation alloc] initWithDistance:distance.doubleValue
                                                       degrees:kNVWest
                                                fromCoordinate:self.coordinate] autorelease];
        
        [annotations addObject:placemark];
    }
}


@end
