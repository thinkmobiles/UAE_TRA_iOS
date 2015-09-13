//
//  UIColor+AppColor.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "UIColor+AppColor.h"

@implementation UIColor (AppColor)

#pragma mark - Public

#pragma mark - AppColors

+ (UIColor *)defaultOrangeColor
{
    return [UIColor colorWithRealRed:243 green:125 blue:27 alpha:1.0f];
}

+ (UIColor *)defaultBlueColor
{
    return [UIColor colorWithRealRed:31 green:32 blue:110 alpha:1.0f];
}

+ (UIColor *)defaultGreenColor
{
    return [UIColor colorWithRealRed:23 green:98 blue:49 alpha:1.0f];
}

+ (UIColor *)tabBarTextColor
{
    return [UIColor colorWithRealRed:34 green:34 blue:34 alpha:1.0f];
}

#pragma mark - HomeViewController

+ (UIColor *)itemGradientTopColor
{
    return [UIColor colorWithRealRed:54 green:67 blue:76 alpha:1.0f];
}

+ (UIColor *)itemGradientBottomColor
{
    return [UIColor colorWithRealRed:65 green:116 blue:134 alpha:1.0f];
}

+ (UIColor *)menuItemGrayColor
{
    return [UIColor colorWithRealRed:188 green:187 blue:186 alpha:1.0f];
}

#pragma mark - TabBarColors

+ (UIColor *)lightGrayTabBarColor
{
    return [UIColor colorWithRealRed:241 green:241 blue:241 alpha:1.0f];
}

+ (UIColor *)darkGrayTabBarColor
{
    return [UIColor colorWithRealRed:215 green:214 blue:213 alpha:1.0f];
}

#pragma mark - FavouriteViewController

+ (UIColor *)lightOrangeColor
{
    return [UIColor colorWithRealRed:255 green:243 blue:229 alpha:1.0f];
}

#pragma mark - InfoHubDetailsViewController

+ (UIColor *)lightGrayTextColor
{
    return [UIColor colorWithRealRed:158 green:158 blue:158 alpha:1.0f];
}

#pragma mark - Services

+ (UIColor *)lightGrayBorderColor
{
    return [UIColor colorWithRealRed:192 green:192 blue:192 alpha:1.0f];
}

+ (UIColor *)lightGreenTextColor
{
    return [UIColor colorWithRealRed:42 green:171 blue:93 alpha:1.0f];
}

+ (UIColor *)redTextColor
{
    return [UIColor colorWithRealRed:229 green:1 blue:28 alpha:1.0f];
}

+ (UIColor *)grayBorderTextFieldTextColor
{
    return [UIColor colorWithRealRed:179 green:179 blue:179 alpha:1.0f];
}




#pragma mark - Private

+ (UIColor *)colorWithRealRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:((float)red)/255.f green:((float)green)/255.f blue:((float)blue)/255.f alpha:((float)alpha)/1.f];
}

@end
