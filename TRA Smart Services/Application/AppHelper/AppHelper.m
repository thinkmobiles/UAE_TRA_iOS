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
#import "UIColor+AppColor.h"
#import "UIImage+DrawText.h"

static CGFloat const MaximumTabBarFontSize = 15.f;
static CGFloat const MinimumTabBarFontSize = 10.f;

static LanguageType startLanguage;

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

+ (void)presentViewController:(UIViewController *)target onController:(UIViewController *)presenter
{
    target.modalPresentationStyle = UIModalPresentationOverFullScreen;
    presenter.modalPresentationStyle = UIModalPresentationCurrentContext;
    [presenter presentViewController:target animated:NO completion:nil];
}

+ (BOOL)isiOS9_0OrHigher
{
    BOOL isiOS9ORHigher = NO;
    NSOperatingSystemVersion ios9_0_0 = (NSOperatingSystemVersion){9, 0, 0};
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios9_0_0]) {
        isiOS9ORHigher = YES;
    }
    return isiOS9ORHigher;
}

#pragma mark - InformationView

+ (void)alertViewWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[AppHelper appName] message:message delegate:nil cancelButtonTitle:dynamicLocalizedString(@"uiElement.OKButton.title") otherButtonTitles: nil] show];
    });
}

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[AppHelper appName] message:message delegate:alertViewDelegate cancelButtonTitle:dynamicLocalizedString(@"uiElement.OKButton.title") otherButtonTitles: nil] show];
    });
}

+ (void)alertViewWithMessage:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)alertViewDelegate otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:[AppHelper appName] message:message delegate:alertViewDelegate cancelButtonTitle:dynamicLocalizedString(@"uiElement.OKButton.title") otherButtonTitles:otherButtonTitles, nil] show];
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
    startLanguage = [DynamicUIService service].language;
    
    [AppHelper performResetupTabBar];
    if (![AppHelper isiOS9_0OrHigher]) {
        if ([DynamicUIService service].language == LanguageTypeArabic) {
            UITabBarController *tabBarController = (UITabBarController *)[AppHelper rootViewController];
            NSArray *viewControllers = [tabBarController.viewControllers reversedArray];
            tabBarController.viewControllers = viewControllers;
            tabBarController.selectedViewController = [viewControllers lastObject];
        }
    }
}

+ (void)performResetupTabBar
{
    NSArray *localizedMenuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarMenuList" ofType:@"plist"]];
    CGFloat fontSize = [AppHelper fontSizeForTabBar];
    UIFont *font = [UIFont latoRegularWithSize:fontSize];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        font = [UIFont droidKufiRegularFontForSize:fontSize];
    }
    
    NSDictionary *parameters = @{ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : [UIColor tabBarTextColor] };
    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite ? [UIColor blackColor] : [UIColor itemGradientTopColor];
    tabBar.backgroundColor = [UIColor menuItemGrayColor];
    
    for (int idx = 0; idx < tabBar.items.count; idx++) {
        UITabBarItem *tabBarItem = tabBar.items[idx];
        NSString *title = dynamicLocalizedString([localizedMenuItems[idx] valueForKey:@"title"]);
        tabBarItem.title = title;
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateSelected];
        
        [tabBarItem setSelectedImage:[UIImage imageNamed:[localizedMenuItems[idx] valueForKey:@"selectedImage"]]];
        [tabBarItem setImage:[UIImage imageNamed:[localizedMenuItems[idx] valueForKey:@"normalImage"]]];
    }
}

+ (void)localizeTitlesOnTabBar
{
    NSArray *localizedMenuItems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarMenuList" ofType:@"plist"]];
    if ([AppHelper isiOS9_0OrHigher] ) {
        if (startLanguage == LanguageTypeArabic) {
            if ([DynamicUIService service].language == LanguageTypeEnglish) {
                localizedMenuItems = [localizedMenuItems reversedArray];
            }
        } else {
            if ([DynamicUIService service].language == LanguageTypeArabic) {
                localizedMenuItems = [localizedMenuItems reversedArray];
            }
        }
    } else {
        if ([DynamicUIService service].language == LanguageTypeArabic) {
            localizedMenuItems = [localizedMenuItems reversedArray];
        }
    }
    
    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite ? [UIColor blackColor] : [UIColor itemGradientTopColor];
    tabBar.backgroundColor = [UIColor menuItemGrayColor];
    
    for (int idx = 0; idx < tabBar.items.count; idx++) {
        UITabBarItem *tabBarItem = tabBar.items[idx];
        NSString *title = dynamicLocalizedString([localizedMenuItems[idx] valueForKey:@"title"]);
        tabBarItem.title = title;
    }
}

//ok
+ (void)updateFontsOnTabBar
{
    CGFloat fontSize = [AppHelper fontSizeForTabBar];
    UIFont *font = [UIFont latoRegularWithSize:fontSize];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        font = [UIFont droidKufiRegularFontForSize:fontSize];
    }

    NSDictionary *parameters = @{ NSFontAttributeName :font,
                                  NSForegroundColorAttributeName : [UIColor tabBarTextColor] };

    UITabBar *tabBar = [AppHelper rootViewController].tabBar;
    tabBar.tintColor = [DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite ? [UIColor blackColor] : [UIColor itemGradientTopColor];
    tabBar.backgroundColor = [UIColor menuItemGrayColor];
    
    for (int idx = 0; idx < tabBar.items.count; idx++) {
        UITabBarItem *tabBarItem = tabBar.items[idx];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateSelected];
    }
}

//ok
+ (CGFloat)fontSizeForTabBar
{
    CGFloat fontSize = [DynamicUIService service].fontSize;
    
    if (fontSize) {
        fontSize = fontSize == 2 ? MaximumTabBarFontSize : MinimumTabBarFontSize;
    } else {
        fontSize = 12.f;
    }
    return fontSize;
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
    tabBar.tintColor = [DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite ? [UIColor blackColor] : [UIColor itemGradientTopColor];
}

#pragma mark - NavigationBar Configuration

+ (void)updateNavigationBarColor
{
    UITabBarController *tabBarController = (UITabBarController *)[AppHelper rootViewController];
    for (UINavigationController *viewController in tabBarController.viewControllers) {
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UIColor *uiColor = [[DynamicUIService service].currentApplicationColor colorWithAlphaComponent:0.8f];
            UIImage *backgroundImage = [UIImage imageWithColor:uiColor inRect:CGRectMake(0, 0, 1, 1)];
            [viewController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
            viewController.navigationBar.barTintColor = [UIColor whiteColor];
        }
    }
}

+ (void)titleFontForNavigationBar:(UINavigationBar *)navigationBar
{
    [navigationBar setTitleTextAttributes:@{
                                            NSFontAttributeName : [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                            NSForegroundColorAttributeName : [UIColor whiteColor]
                                            }];
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

+ (void)addHexagoneOnView:(UIView *)view
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.layer.bounds;
    maskLayer.path = [AppHelper hexagonPathForView:view].CGPath;
    view.layer.mask = maskLayer;
}

+ (void)addHexagonBorderForLayer:(CALayer *)layer color:(UIColor *)color width:(CGFloat) width
{
    CAShapeLayer *borderlayer = [CAShapeLayer layer];
    borderlayer.fillColor = [UIColor clearColor].CGColor;
    borderlayer.strokeColor = color ? color.CGColor : [[DynamicUIService service] currentApplicationColor].CGColor;
    borderlayer.lineWidth = width;
    borderlayer.frame = layer.bounds;
    borderlayer.path = [AppHelper hexagonPathForRect:layer.bounds].CGPath;
    
    [layer addSublayer:borderlayer];
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
    layer.cornerRadius = 3;
    layer.borderWidth = 1;
    layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
}

+ (void)setStyleGrayColorForLayer:(CALayer *)layer
{
    layer.cornerRadius = 0;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor grayBorderTextFieldTextColor].CGColor;
}

+ (UIImage *)snapshotForView:(UIView *)view
{
    CGSize size = CGSizeMake(view.bounds.size.width, view.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snapshot;
}

@end