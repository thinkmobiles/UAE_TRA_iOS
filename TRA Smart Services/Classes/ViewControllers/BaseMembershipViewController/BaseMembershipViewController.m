//
//  BaseMembershipViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "TextFieldNavigator.h"
#import "BaseMembershipViewController.h"

@interface BaseMembershipViewController ()

@end

@implementation BaseMembershipViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self prepareNavigationBar];
    [self prepareUIElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareNotification];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.contentSize = [UIScreen mainScreen].bounds.size;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [TextFieldNavigator findNextTextFieldFromCurrent:textField];
    if (textField.returnKeyType == UIReturnKeyDone) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.scrollView.contentOffset = CGPointZero;
        }];
        [self returnKeyDone];
        return YES;
    }
    return NO;
}

#pragma mark - Public

- (void)prepareNavigationBar
{
    [self.navigationController presentTransparentNavigationBarAnimated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)returnKeyDone
{
    
}

#pragma mark - Private

- (void)prepareUIElements
{
    self.mainButton.layer.cornerRadius = 2.5f;
}

#pragma mark - Keyboard

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    CGFloat bottomRequiredVisiblePointYPosition = self.containerView.frame.origin.y + self.containerView.frame.size.height;
    CGFloat offsetForScrollViewY = keyboardHeight - ([UIScreen mainScreen].bounds.size.height - bottomRequiredVisiblePointYPosition);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetForScrollViewY < 50.f ? 50.f : offsetForScrollViewY)];
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.scrollView setContentOffset:CGPointZero];
        [weakSelf.view layoutIfNeeded];
    }];
}

@end