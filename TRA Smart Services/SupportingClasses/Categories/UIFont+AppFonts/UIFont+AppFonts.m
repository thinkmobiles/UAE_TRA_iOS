//
//  UIFont+AppFonts.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "UIFont+AppFonts.h"

@implementation UIFont (AppFonts)

#pragma mark - Public

+ (UIFont *)droidKufiBoldFontForSize:(CGFloat)size
{
    return [UIFont fontWithName:@"DroidArabicKufi-Bold" size:size];
}

+ (UIFont *)droidKufiRegularFontForSize:(CGFloat)size
{
    return [UIFont fontWithName:@"DroidArabicKufi" size:size];
}

+ (UIFont *)latoRegularWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

+ (UIFont *)latoBlackWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Black" size:size];
}

+ (UIFont *)latoLightWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Light" size:size];
}

+ (UIFont *)latoBoldWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

@end