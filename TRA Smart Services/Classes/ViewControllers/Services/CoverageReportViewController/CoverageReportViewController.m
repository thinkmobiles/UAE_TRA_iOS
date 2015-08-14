//
//  CoverageReportViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CoverageReportViewController.h"

@interface CoverageReportViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISlider *signalLevelSlider;
@property (weak, nonatomic) IBOutlet UIButton *reportSignalButton;

@end

@implementation CoverageReportViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Coverage Report";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self prepareUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppHelper showLoader];
    [LocationManager sharedManager].delegate = self;
    [[LocationManager sharedManager] startUpdatingLocation];
}

#pragma mark - LocationManagerDelegate

- (void)locationDidChangedTo:(CGFloat)longtitude lat:(CGFloat)latitude
{
    self.reportSignalButton.userInteractionEnabled = YES;
    [self.activityIndicator startAnimating];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    __weak typeof(self) weakSelf = self;
    [[LocationManager sharedManager] fetchAddressWithLocation:loc completionBlock:^(NSString *address) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.addressTextField.text = address;
            [weakSelf.activityIndicator stopAnimating];
        });
        [AppHelper hideLoader];
    }];
}

- (void)locationDidFailWithError:(NSError *)failError
{
    [AppHelper hideLoader];
    [AppHelper alertViewWithMessage:failError.localizedDescription];
}

#pragma mark - IbAction

- (IBAction)reportSignalButtonTapped:(id)sender
{
    if ([LocationManager sharedManager].currentLattitude || self.addressTextField.text.length) {
        [AppHelper showLoader];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTPoorCoverageAtLatitude:[LocationManager sharedManager].currentLattitude longtitude:[LocationManager sharedManager].currentLongtitude address:self.addressTextField.text signalPower:self.signalLevelSlider.value  requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:response];
            }
            weakSelf.addressTextField.text = @"";
            [AppHelper hideLoader];
        }];
    } else {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    }
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
