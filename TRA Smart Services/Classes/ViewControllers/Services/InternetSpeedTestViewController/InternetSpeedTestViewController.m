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
    [super updateColors];
    
    self.activityIndicator.color = [self.dynamicService currentApplicationColor];
}

@end
