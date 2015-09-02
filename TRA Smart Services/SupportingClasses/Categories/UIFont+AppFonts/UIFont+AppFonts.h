//
//  UIFont+AppFonts.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const LatoFontPrefix = @"Lato";
static NSString *const DroidFontPrefix = @"Droid";

@interface UIFont (AppFonts)

+ (UIFont *)droidKufiBoldFontForSize:(CGFloat)size;
+ (UIFont *)droidKufiRegularFontForSize:(CGFloat)size;

+ (UIFont *)latoRegularWithSize:(CGFloat)size;
+ (UIFont *)latoBlackWithSize:(CGFloat)size;
+ (UIFont *)latoLightWithSize:(CGFloat)size;
+ (UIFont *)latoBoldWithSize:(CGFloat)size;

@end
