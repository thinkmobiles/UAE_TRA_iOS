//
//  AppHelper.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AppHelper.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

static CGFloat const MaximumTabBarFontSize = 15.f;

@implementation AppHelper

#pragma mark - Public

#pragma mark - Common

+ (UITabBarController *)rootViewController
{
    return (UITabBarController *)[((AppDelegate *)[UIApplication sharedApplication].delegate).window rootViewController];
}

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

+ (UIView *)topView
{
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - InformationView

+ (void)alertViewWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[AppHelper appName] message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    });
}

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[AppHelper appName] message:message delegate:alertViewDelegate cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    });
}

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[AppHelper appName] message:message delegate:alertViewDelegate cancelButtonTitle:@"OK" otherButtonTitles:otherButtonTitles, nil] show];
    });
}

+ (void)showLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:[AppHelper topView] animated:YES].dimBackground = YES;
    });
}

+ (void)showLoaderWithText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[AppHelper topView]];
        hud.removeFromSuperViewOnHide = YES;
        hud.labelText = text;
        [[AppHelper topView] addSubview:hud];
        [hud show:YES];
    });
}

+ (void)hideLoader
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:[AppHelper topView] animated:YES];
    });
}

#pragma mark - TabBarConfiguration

- (void)prepareTabBarItems
{
    NSArray *localizedMenuItems = [self localizedTabBarMenuItems];
    CGFloat fontSize = [DynamicUIService service].fontSize;
    fontSize = fontSize > MaximumTabBarFontSize ? MaximumTabBarFontSize : fontSize;
    NSDictionary *parameters = @{ NSFontAttributeName : [UIFont fontWithName:@"Avenir-Roman" size:fontSize],
                                  NSForegroundColorAttributeName : [UIColor tabBarTextColor] };
    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    
    [tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * __nonnull tabBarItem, NSUInteger idx, BOOL * __nonnull stop) {
        tabBarItem.title = localizedMenuItems[idx];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateSelected];
    }];
}

#pragma mark - Private

- (NSArray *)localizedTabBarMenuItems
{
    NSArray *menuItemsLink = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarMenuList" ofType:@"plist"]];
    NSMutableArray *localizedMenuItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < menuItemsLink.count; i++) {
        [localizedMenuItems addObject:dynamicLocalizedString(menuItemsLink[i])];
    }
    return localizedMenuItems;
}

@end