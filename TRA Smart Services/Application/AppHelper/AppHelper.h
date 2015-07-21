//
//  AppHelper.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface AppHelper : NSObject

+ (UITabBarController *)rootViewController;
+ (UIView *)topView;

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate;
+ (void)alertViewWithMessage:(NSString *)message;

+ (NSString *)appName;

+ (void)showLoader;
+ (void)showLoaderWithText:(NSString *)text;
+ (void)hideLoader;

- (void)prepareTabBarItems;

@end