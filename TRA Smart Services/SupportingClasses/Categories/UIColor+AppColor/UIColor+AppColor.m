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

#pragma mark - Private

+ (UIColor *)colorWithRealRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:((float)red)/255.f green:((float)green)/255.f blue:((float)blue)/255.f alpha:((float)alpha)/1.f];
}

@end
