//
//  NVAppDelegate.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVAppDelegate.h"

#import "NVMapViewController.h"
#import "NVLocationViewController.h"
#import "NVCompassViewController.h"
#import "NVTabBarController.h"

#import "UIWindow+TDExtensions.h"
#import "UIViewController+IDPInitialization.h"
#import "NSObject+IDPExtensions.h"

@interface NVAppDelegate ()

@end

@implementation NVAppDelegate

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.window = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

-           (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow window];
    UIWindow *window = self.window;

    window.backgroundColor = [UIColor whiteColor];
    window.rootViewController = [NVTabBarController viewControllerWithDefaultNib];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
