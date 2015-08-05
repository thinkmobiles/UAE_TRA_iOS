//
//  AppDelegate.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AppDelegate.h"

#import "InternetSpeedChecker.h"

@interface AppDelegate () <InternetSpeedCheckerDelegate>

@end

@implementation AppDelegate

#pragma mark - LifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DynamicUIService service];
    [AppHelper prepareTabBarItems];
    
    InternetSpeedChecker *speedCheker = [[InternetSpeedChecker alloc] init];
    [speedCheker performFastInternetSpeedTest];
    
    return YES;
}

#pragma mark - InternetSpeedCheckerDelegate

- (void)speedCheckerDidCalculateSpeed:(CGFloat)speed
{
    NSLog(@"Your speed - %f.1", speed);
}

@end
