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
#import "DynamicUIService.h"

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
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
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

+ (void)prepareTabBarItems
{
    [AppHelper performResetupTabBar];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        UITabBarController *tabBarController = (UITabBarController *)[AppHelper rootViewController];
        NSArray *viewControllers = [tabBarController.viewControllers reversedArray];
        tabBarController.viewControllers = viewControllers;
        tabBarController.selectedViewController = [viewControllers lastObject];
    }
}

+ (void)performResetupTabBar
{
    NSArray *localizedMenuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarMenuList" ofType:@"plist"]];
    CGFloat fontSize = [DynamicUIService service].fontSize;
    fontSize = fontSize == 2 ? MaximumTabBarFontSize : 12.f;
    UIFont *font = [UIFont latoRegularWithSize:fontSize];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        font = [UIFont droidKufiRegularFontForSize:fontSize];
    }
    
    NSDictionary *parameters = @{ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : [UIColor tabBarTextColor] };
    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [DynamicUIService service].currentApplicationColor;
    tabBar.backgroundColor = [UIColor menuItemGrayColor];
    
    for (int idx = 0; idx < tabBar.items.count; idx++) {
        UITabBarItem *tabBarItem = tabBar.items[idx];
        tabBarItem.title = dynamicLocalizedString([localizedMenuItems[idx] valueForKey:@"title"]);
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateSelected];
        
        [tabBarItem setSelectedImage:[UIImage imageNamed:[localizedMenuItems[idx] valueForKey:@"selectedImage"]]];
        [tabBarItem setImage:[UIImage imageNamed:[localizedMenuItems[idx] valueForKey:@"normalImage"]]];
    }
}

+ (void)localizeTitlesOnTabBar
{
    NSArray *localizedMenuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarMenuList" ofType:@"plist"]];
    
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        localizedMenuItems = [localizedMenuItems reversedArray];
    }
    
    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [DynamicUIService service].currentApplicationColor;
    tabBar.backgroundColor = [UIColor menuItemGrayColor];
    
    for (int idx = 0; idx < tabBar.items.count; idx++) {
        UITabBarItem *tabBarItem = tabBar.items[idx];
        tabBarItem.title = dynamicLocalizedString([localizedMenuItems[idx] valueForKey:@"title"]);
    }
}

+ (void)updateFontsOnTabBar
{
    CGFloat fontSize = [DynamicUIService service].fontSize;
    fontSize = fontSize == 2 ? MaximumTabBarFontSize : 12.f;
    
    UIFont *font = [UIFont latoRegularWithSize:fontSize];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        font = [UIFont droidKufiRegularFontForSize:fontSize];
    }

    NSDictionary *parameters = @{ NSFontAttributeName :font,
                                  NSForegroundColorAttributeName : [UIColor tabBarTextColor] };

    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [DynamicUIService service].currentApplicationColor;
    tabBar.backgroundColor = [UIColor menuItemGrayColor];
    
    for (int idx = 0; idx < tabBar.items.count; idx++) {
        UITabBarItem *tabBarItem = tabBar.items[idx];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateSelected];
    }
}

+ (void)prepareTabBarGradient
{
    UITabBarController *tabBarController = (UITabBarController *)[AppHelper rootViewController];
    
    CAGradientLayer *headerGradient = [CAGradientLayer layer];
    CGRect gradientFrame = tabBarController.tabBar.bounds;
    headerGradient.frame = gradientFrame;
    headerGradient.colors = @[(id)[UIColor lightGrayTabBarColor].CGColor, (id)[UIColor darkGrayTabBarColor].CGColor];
    
    UIGraphicsBeginImageContext(tabBarController.tabBar.bounds.size);
    [headerGradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [tabBarController.tabBar setBackgroundImage:viewImage];
}

+ (void)reverseTabBarItems
{
    UITabBarController *tabBarController = (UITabBarController *)[AppHelper rootViewController];
    NSArray *viewControllers = [tabBarController.viewControllers reversedArray];
    tabBarController.viewControllers = viewControllers;
}

+ (void)updateTabBarTintColor
{
    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [DynamicUIService service].currentApplicationColor;
}

#pragma mark - NavigationBar Configuration

+ (void)updateNavigationBarColor
{
    UITabBarController *tabBarController = (UITabBarController *)[AppHelper rootViewController];
    for (UINavigationController *viewController in tabBarController.viewControllers) {
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController.navigationBar.barTintColor = [DynamicUIService service].currentApplicationColor;
            viewController.navigationBar.translucent = NO;
        }
    }
}

#pragma mark - Hexagon

+ (UIBezierPath *)hexagonPathForView:(UIView *)view
{
    CGRect hexagonRect = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
    return [AppHelper hexagonPathForRect:hexagonRect];
}

+ (UIBezierPath *)hexagonPathForRect:(CGRect)hexagonRect
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    [hexagonPath moveToPoint:CGPointMake(CGRectGetMidX(hexagonRect), 0)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMidX(hexagonRect), CGRectGetMaxY(hexagonRect))];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMidX(hexagonRect), 0)];
    
    return hexagonPath;
}

#pragma mark - Date

+ (NSString *)detailedDateStringFrom:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LLLL dd, yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

+ (NSString *)compactDateStringFrom:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/d/yy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

#pragma mark - UI Customizations

+ (void)setStyleForLayer:(CALayer *)layer
{
    layer.cornerRadius = 8;
    layer.borderWidth = 1;
    layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
}


@end