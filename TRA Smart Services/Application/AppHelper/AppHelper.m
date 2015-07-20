//
//  AppHelper.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AppHelper.h"
#import "MBProgressHUD.h"

@implementation AppHelper

#pragma mark - Public

+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

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

+ (UIView *)topView
{
    return [UIApplication sharedApplication].keyWindow;
}

@end