//
//  InternetSpeedTestViewController.m
//  TRA Smart Services
//
//  Created by Admin on 13.08.15.
//

#import "InternetSpeedTestViewController.h"

@interface InternetSpeedTestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *speedTestResult;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (strong, nonatomic) TRALoaderViewController *loader;
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
    self.loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:YES];
    __weak typeof(self) weakSelf = self;
    self.loader.TRALoaderWillClose = ^() {
        [weakSelf.speedChecker stopTest];
    };
}

#pragma mark - InternetSpeedCheckerDelegate

- (void)speedCheckerDidCalculateSpeed:(CGFloat)speed testMethod:(SpeedTestType)method
{
    if (!method) {
        self.speedTestResult.text = [NSString stringWithFormat:dynamicLocalizedString(@"InternetSpeedTestViewController.speedTestResult.text"), speed];
    } else {
        self.speedTestResult.text = [NSString stringWithFormat:dynamicLocalizedString(@"InternetSpeedTestViewController.speedTestResult.text.accurate"), speed];
    }
    [self.loader dismissTRALoader];
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

    [super updateBackgroundImageNamed:@"img_bg_service"];
}

@end
