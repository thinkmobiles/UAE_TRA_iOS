//
//  BaseServiceViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseServiceViewController.h"
#import "LoginViewController.h"

@interface BaseServiceViewController ()

@end

@implementation BaseServiceViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
}

#pragma mark - Public

- (void)presentLoginIfNeeded
{
    if (![NetworkManager sharedManager].isUserLoggined) {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
        viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
#endif
        __weak typeof(self) weakSelf = self;
        ((LoginViewController *)viewController.topViewController).didCloseViewController = ^() {
            if (![NetworkManager sharedManager].isUserLoggined) {
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            }
        };
        ((LoginViewController *)viewController.topViewController).shouldAutoCloseAfterLogin = YES;
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.navigationController presentViewController:viewController animated:NO completion:nil];
    }
}

#pragma mark - Superclass methods

- (void)updateColors
{
    [self updateSubviewColor:self.view];
}

- (void)updateSubviewColor:(UIView *)mainView
{
    NSArray *subViews = mainView.subviews;
    if (subViews.count) {
        for (UIView * subView in subViews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [AppHelper setStyleForLayer:subView.layer];
                [(UIButton *)subView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                subView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
            } else if ([subView isKindOfClass:[UITextField class]]) {
                [AppHelper setStyleGrayColorForLayer:subView.layer];
                [(UITextField *)subView setValue:[UIColor grayBorderTextFieldTextColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            [self updateSubviewColor:subView ];
        }
    }
}

@end
