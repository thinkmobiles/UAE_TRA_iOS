//
//  UIColor+AppColor.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface UIColor (AppColor)

#pragma mark - AppColors

+ (UIColor *)defaultOrangeColor;
+ (UIColor *)defaultBlueColor;
+ (UIColor *)defaultGreenColor;
+ (UIColor *)tabBarTextColor;

#pragma mark - HomeViewController

+ (UIColor *)itemGradientTopColor;
+ (UIColor *)itemGradientBottomColor;
+ (UIColor *)menuItemGrayColor;

#pragma mark - TabBarColors

+ (UIColor *)lightGrayTabBarColor;
+ (UIColor *)darkGrayTabBarColor;

#pragma mark - FavouriteViewController

+ (UIColor *)lightOrangeColor;

@end
