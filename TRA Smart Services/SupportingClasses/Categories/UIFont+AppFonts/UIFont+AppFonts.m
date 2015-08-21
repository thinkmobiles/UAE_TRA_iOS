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
    return [UIFont fontWithName:@"Droid Arabic Kufi Bold" size:size];
}

+ (UIFont *)droidKufiRegularFontForSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Droid Arabic Kufi" size:size];
}

@end