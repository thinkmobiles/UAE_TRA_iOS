//
//  InternetSpeedTestViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InternetSpeedTestViewController.h"

@interface InternetSpeedTestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *speedTestResult;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (strong, nonatomic) InternetSpeedChecker *speedChecker;

@end

@implementation InternetSpeedTestViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.speedChecker = [[InternetSpeedChecker alloc] init];
    self.speedChecker.delegate = self;
}

#pragma mark - IBActions

- (IBAction)checkInternetSpeedButtonTapped:(id)sender
{
    [self.speedChecker performAccurateInternetTest];
    [self.activityIndicator startAnimating];
}

#pragma mark - InternetSpeedCheckerDelegate

- (void)speedCheckerDidCalculateSpeed:(CGFloat)speed testMethod:(SpeedTestType)method
{
    if (!method) {
        self.speedTestResult.text = [NSString stringWithFormat:dynamicLocalizedString(@"InternetSpeedTestViewController.speedTestResult.text"), speed];
    } else {
        self.speedTestResult.text = [NSString stringWithFormat:dynamicLocalizedString(@"InternetSpeedTestViewController.speedTestResult.text.accurate"), speed];
    }
    [self.activityIndicator stopAnimating];
    self.checkButton.enabled = YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"internetSpeedTestViewController.title");
    [self.checkButton setTitle:dynamicLocalizedString(@"internetSpeedTestViewController.checkButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    for (UILabel *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.textColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [AppHelper setStyleForLayer:subView.layer];
            [(UIButton *)subView setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
        } else if ([subView isKindOfClass:[UITextField class]]) {
            [AppHelper setStyleForLayer:subView.layer];
            ((UITextField *)subView).textColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    self.activityIndicator.color = [[DynamicUIService service] currentApplicationColor];
}

@end
