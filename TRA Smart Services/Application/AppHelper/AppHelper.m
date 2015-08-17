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
    NSArray *localizedMenuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarMenuList" ofType:@"plist"]];
    CGFloat fontSize = [DynamicUIService service].fontSize;
    fontSize = fontSize > MaximumTabBarFontSize ? MaximumTabBarFontSize : fontSize;
    NSDictionary *parameters = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Light" size:fontSize],
                                  NSForegroundColorAttributeName : [UIColor tabBarTextColor] };
    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [UIColor defaultOrangeColor];
    tabBar.backgroundColor = [UIColor menuItemGrayColor];
    
    for (int idx = 0; idx < tabBar.items.count; idx++) {
        UITabBarItem *tabBarItem = tabBar.items[idx];
        tabBarItem.title = dynamicLocalizedString([localizedMenuItems[idx] valueForKey:@"title"]);
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateSelected];
        
        [tabBarItem setSelectedImage:[UIImage imageNamed:[localizedMenuItems[idx] valueForKey:@"selectedImage"]]];
        [tabBarItem setImage:[UIImage imageNamed:[localizedMenuItems[idx] valueForKey:@"normalImage"]]];
    }
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        UITabBarController *tabBarController = (UITabBarController *)[AppHelper rootViewController];
        NSArray *viewControllers = [tabBarController.viewControllers reversedArray];
        tabBarController.viewControllers = viewControllers;
        tabBarController.selectedViewController = [viewControllers lastObject];
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



@end