//
//  AppHelper.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#define TRANFORM_3D_SCALE CATransform3DMakeScale(-1, 1, 1)
@class BottomBorderTextField;
@class BottomBorderTextView;

@interface AppHelper : NSObject

+ (UITabBarController *)rootViewController;
+ (UIView *)topView;

+ (void)presentViewController:(UIViewController *)target onController:(UIViewController *)presenter;
+ (BOOL)isiOS9_0OrHigher;

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate otherButtonTitles:(NSString *)otherButtonTitles, ...;
+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate;
+ (void)alertViewWithMessage:(NSString *)message;

+ (NSString *)appName;

+ (void)showLoader;
+ (void)showLoaderWithText:(NSString *)text;
+ (void)hideLoader;

+ (void)prepareTabBarItems;
+ (void)performResetupTabBar;
+ (void)updateFontsOnTabBar;
+ (void)localizeTitlesOnTabBar;
+ (void)reverseTabBarItems;
+ (void)prepareTabBarGradient;
+ (void)updateTabBarTintColor;

+ (void)updateNavigationBarColor;
+ (void)titleFontForNavigationBar:(UINavigationBar *)navigationBar;

+ (UIBezierPath *)hexagonPathForView:(UIView *)view;
+ (UIBezierPath *)hexagonPathForRect:(CGRect)hexagonRect;
+ (void)addHexagoneOnView:(UIView *)view;
+ (void)addHexagonBorderForLayer:(CALayer *)layer color:(UIColor *)color width:(CGFloat) width;

+ (NSString *)detailedDateStringFrom:(NSDate *)date;
+ (NSString *)compactDateStringFrom:(NSDate *)date;

+ (void)setStyleForLayer:(CALayer *)layer;
+ (void)setStyleForTextField:(BottomBorderTextField *)textField;
+ (void)setStyleForTextView:(BottomBorderTextView *)textView;
+ (void)setStyleGrayColorForLayer:(CALayer *)layer;

+ (UIImage *)snapshotForView:(UIView *)view;

@end