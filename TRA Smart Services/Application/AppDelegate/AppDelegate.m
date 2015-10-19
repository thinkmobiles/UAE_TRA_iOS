//
//  AppDelegate.m
//  TRA Smart Services
//
//  Created by Admin on 13.07.15.
//

#import "AppDelegate.h"
#import "AutoLoginService.h"
#import "FingerPrintAuth.h"
#import "KeychainStorage.h"
#import "SettingViewController.h"
#import "ReverseSecure.h"

@interface AppDelegate ()

@property (strong, nonatomic) FingerPrintAuth *touchAuth;
@property (strong, nonatomic) AutoLoginService *autoLogger;

@end

@implementation AppDelegate

#pragma mark - LifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([ReverseSecure isJailBroken]) {
        [[[UIAlertView alloc] initWithTitle:@"JailbrakeDevice" message:dynamicLocalizedString(@"message.JailbrakeDevice") delegate:nil cancelButtonTitle:nil otherButtonTitles: nil] show];
    } else {
        [CoreDataManager sharedManager];
        [DynamicUIService service];
        [BlackWhiteConverter sharedManager];
        [[NetworkManager sharedManager] startMonitoringNetwork];
        
        [AppHelper prepareTabBarItems];
        [AppHelper prepareTabBarGradient];
        
        [self performAutoLogin];
        self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    }
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