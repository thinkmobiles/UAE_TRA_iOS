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
    [AppHelper prepareTabBarGradient];
    
    InternetSpeedChecker *speedCheker = [[InternetSpeedChecker alloc] init];
    [speedCheker performFastInternetSpeedTest];
    speedCheker.delegate = self;
    
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
    }
     
     return YES;
}

#pragma mark - InternetSpeedCheckerDelegate

- (void)speedCheckerDidCalculateSpeed:(CGFloat)speed testMethod:(SpeedTestType)method
{
    if (!method) {
        NSLog(@"Your speed - %.6f Mb/sec", speed);
    } else {
        NSLog(@"Your speed - %.6f Mb/sec (accurate)", speed);
    }
}

@end
