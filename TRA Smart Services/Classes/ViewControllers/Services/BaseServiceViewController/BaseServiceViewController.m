//
//  BaseServiceViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseServiceViewController.h"
#import "LoginViewController.h"

@implementation BaseServiceViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
}

#pragma mark - Public

- (void)presentLoginIfNeeded
{
    if (![NetworkManager sharedManager].isUserLoggined) {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        __weak typeof(self) weakSelf = self;
        ((LoginViewController *)viewController.topViewController).didCloseViewController = ^() {
            if (![NetworkManager sharedManager].isUserLoggined) {
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            }
        };
        ((LoginViewController *)viewController.topViewController).shouldAutoCloseAfterLogin = YES;
        [AppHelper presentViewController:viewController onController:self.navigationController];
    }
}

#pragma mark - Superclass methods

- (void)updateColors
{
    for (UILabel *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.textColor = [self.dynamicService currentApplicationColor];
        }
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [AppHelper setStyleForLayer:subView.layer];
            [(UIButton *)subView setTitleColor:[self.dynamicService currentApplicationColor] forState:UIControlStateNormal];
        } else if ([subView isKindOfClass:[UITextField class]]) {
            [AppHelper setStyleForLayer:subView.layer];
        }
    }
}

@end
