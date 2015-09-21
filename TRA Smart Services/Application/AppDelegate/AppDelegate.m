//
//  AppDelegate.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AppDelegate.h"
#import "AutoLoginService.h"
#import "FingerPrintAuth.h"
#import "KeychainStorage.h"
#import "SettingViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) FingerPrintAuth *touchAuth;
@property (strong, nonatomic) AutoLoginService *autoLogger;

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
    
    [self performAutoLogin];
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];

    return YES;
}

#pragma mark - Private

- (void)performAutoLogin
{
    if ([KeychainStorage userName].length) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:KeyUseTouchIDIdentification]) {
            self.touchAuth = [[FingerPrintAuth alloc] init];
            [self.touchAuth authentificationsWithTouch];
        } else {
            self.autoLogger = [[AutoLoginService alloc] init];
            [self.autoLogger performAutoLoginIfPossible];
        }
    }
}

@end