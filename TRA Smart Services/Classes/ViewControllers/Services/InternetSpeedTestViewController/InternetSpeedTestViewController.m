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
    
    [self prepareUI];
    self.title = @"Speed Test Demo";
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
        self.speedTestResult.text = [NSString stringWithFormat:@"Your speed - %.6f Mb/sec", speed];
    } else {
        self.speedTestResult.text = [NSString stringWithFormat:@"Your speed - %.6f Mb/sec (accurate)", speed];
    }
    [self.activityIndicator stopAnimating];
    self.checkButton.enabled = YES;
}

#pragma mark - Private

- (void)prepareUI
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.layer.cornerRadius = 8;
            subView.layer.borderColor = [UIColor defaultOrangeColor].CGColor;
            subView.layer.borderWidth = 1;
        }
    }
}


@end
