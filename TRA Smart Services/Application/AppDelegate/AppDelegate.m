//
//  AppDelegate.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AppDelegate.h"
#import "AutoLoginService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - LifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CoreDataManager sharedManager];
    [DynamicUIService service];
    [BlackWhiteConverter sharedManager];
    [[NetworkManager sharedManager] startMonitoringNetwork];
    
    [AppHelper prepareTabBarItems];
    [AppHelper prepareTabBarGradient];
    AutoLoginService *autoLogger = [[AutoLoginService alloc] init];
    [autoLogger performAutoLoginIfPossible];
    
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];

    return YES;
}

@end