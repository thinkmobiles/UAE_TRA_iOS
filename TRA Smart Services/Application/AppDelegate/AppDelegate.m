//
//  AppDelegate.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AppDelegate.h"

static CGFloat const MaximumTabBarFontSize = 15.f;

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - LifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DynamicUIService service];
    [self prepareTabBarItemsForTabBar:(UITabBarController *)self.window.rootViewController];
    
    return YES;
}

#pragma mark - Private

#pragma mark - TabBarConfiguration

- (void)prepareTabBarItemsForTabBar:(UITabBarController *)tabBarController
{
    NSArray *localizedMenuItems = [self localizedTabBarMenuItems];
    CGFloat fontSize = [DynamicUIService service].fontSize;
    fontSize = fontSize > MaximumTabBarFontSize ? MaximumTabBarFontSize : fontSize;
    NSDictionary *parameters = @{ NSFontAttributeName : [UIFont fontWithName:@"Avenir-Roman" size:fontSize],
                                 NSForegroundColorAttributeName : [UIColor tabBarTextColor] };
    UITabBar *tabBar = tabBarController.tabBar;

    [tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * __nonnull tabBarItem, NSUInteger idx, BOOL * __nonnull stop) {
        tabBarItem.title = localizedMenuItems[idx];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:parameters forState:UIControlStateSelected];
    }];
}

- (NSArray *)localizedTabBarMenuItems
{
    NSArray *menuItemsLink = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarMenuList" ofType:@"plist"]];
    NSMutableArray *localizedMenuItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < menuItemsLink.count; i++) {
        [localizedMenuItems addObject:dynamicLocalizedString(menuItemsLink[i])];
    }
    return localizedMenuItems;
}

@end
