//
//  UINavigationController+Transparent.m
//  PTSquared
//
//  Created by Admin on 23.04.15.
//

#import "UINavigationController+Transparent.h"

@implementation UINavigationController (Transparent)

#pragma mark - Public

- (void)presentTransparentNavigationBarAnimated:(BOOL)animated
{
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self setNavigationBarHidden:NO animated:animated];
}

- (void)hideTransparentNavigationBarAnimated:(BOOL)animated
{
    [self setNavigationBarHidden:YES animated:animated];
    [self.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:[[UINavigationBar appearance] isTranslucent]];
    [self.navigationBar setShadowImage:[[UINavigationBar appearance] shadowImage]];
}

@end