//
//  AppDelegate.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - LifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DynamicUIService service];
    [AppHelper prepareTabBarItems];
    [AppHelper prepareTabBarGradient];
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    
    
    return YES;
}

@end
