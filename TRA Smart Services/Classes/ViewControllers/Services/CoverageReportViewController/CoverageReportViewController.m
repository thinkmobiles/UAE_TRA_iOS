//
//  CoverageReportViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CoverageReportViewController.h"
#import "MBProgressHUD+CancelButton.h"

@interface CoverageReportViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISlider *signalLevelSlider;
@property (weak, nonatomic) IBOutlet UIButton *reportSignalButton;
@property (weak, nonatomic) IBOutlet UIButton *detectLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedSignalLevel;

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (assign, nonatomic) BOOL needToCaptureLocation;

@end

@implementation CoverageReportViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareHUD];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startCapturing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.HUD removeFromSuperview];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - LocationManagerDelegate

- (void)locationDidChangedTo:(CGFloat)longtitude lat:(CGFloat)latitude
{
    [self.HUD hide:YES];
    if (self.needToCaptureLocation) {
        self.needToCaptureLocation = NO;
        [self detectLocationButtonTapped:nil];
    }
}

- (void)locationDidFailWithError:(NSError *)failError
{
    [self.HUD hide:YES];
    [AppHelper alertViewWithMessage:failError.localizedDescription];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - IbAction

- (IBAction)reportSignalButtonTapped:(id)sender
{
    if ([LocationManager sharedManager].currentLattitude || self.addressTextField.text.length) {
        [self.HUD show:YES];

        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTPoorCoverageAtLatitude:[LocationManager sharedManager].currentLattitude longtitude:[LocationManager sharedManager].currentLongtitude address:self.addressTextField.text signalPower:self.signalLevelSlider.value  requestResult:^(id response, NSError *error) {
            if (error) {
                if (error.code == -999) {
                    [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.OperationCanceledByUser")];
                } else {
                    [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
                }
            } else {
                [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
            }
            [weakSelf.HUD hide:YES];

        }];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        [self startCapturing];
    }
}

- (IBAction)sliderDidChnageValue:(UISlider *)sender
{
    sender.value = roundf(sender.value / sender.maximumValue * 5) * sender.maximumValue / 5 ;
    
    NSString *value;
    switch ((int)sender.value) {
        case 1: {
            value = dynamicLocalizedString(@"coverageReport.very_weak");
            break;
        }
        case 2: {
            value = dynamicLocalizedString(@"coverageReport.weak");
            break;
        }
        case 3: {
            value = dynamicLocalizedString(@"coverageReport.good");
            break;
        }
        case 4: {
            value = dynamicLocalizedString(@"coverageReport.strong");
            break;
        }
        case 5: {
            value = dynamicLocalizedString(@"coverageReport.veryStrong");
            break;
        }
        default:
            break;
    }

    self.selectedSignalLevel.text = [NSString stringWithFormat:@"%@ - %@", dynamicLocalizedString(@"coverageLevel.title"), value];
}

- (IBAction)detectLocationButtonTapped:(id)sender
{
    if (![NetworkManager sharedManager].networkStatus) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NoInternetConnection")];
        return;
    }
    if ([LocationManager sharedManager].currentLattitude) {
        [self.activityIndicator startAnimating];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[LocationManager sharedManager].currentLattitude longitude:[LocationManager sharedManager].currentLongtitude];
        __weak typeof(self) weakSelf = self;
        [[LocationManager sharedManager] fetchAddressWithLocation:loc completionBlock:^(NSString *address) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.addressTextField.text = address;
                [weakSelf.activityIndicator stopAnimating];
            });
        }];
    } else {
        self.needToCaptureLocation = YES;
        [self startCapturing];
    }
}

- (void)MBProgressHUDCancelButtonDidPressed
{
    [self.HUD hide:YES];
    [[NetworkManager sharedManager] cancelAllOperations];
    [[LocationManager sharedManager] stopUpdatingLocation];
    [self.activityIndicator stopAnimating];
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"coverageLevel.title");
    self.selectedSignalLevel.text = [NSString stringWithFormat:@"%@ - %@", dynamicLocalizedString(@"coverageLevel.title"), dynamicLocalizedString(@"coverageReport.very_weak")];
    [self.reportSignalButton setTitle:dynamicLocalizedString(@"coverageReport.reportSignalButton.title") forState:UIControlStateNormal];
    [self.detectLocationButton setTitle:dynamicLocalizedString(@"coverageReport.detectLocationButton.title") forState:UIControlStateNormal];
    self.addressTextField.placeholder = dynamicLocalizedString(@"coverageReport.addressTextField");
}

- (void)updateColors
{
    [super updateColors];
    
    self.activityIndicator.color = [self.dynamicService currentApplicationColor];
    self.signalLevelSlider.minimumTrackTintColor = [self.dynamicService currentApplicationColor];
}

#pragma mark - Private

- (void)prepareHUD
{
    self.HUD = [[MBProgressHUD alloc] initWithView:[AppHelper topView]];
    [[AppHelper rootViewController].view addSubview:self.HUD];
    self.HUD.dimBackground = YES;
    [self.HUD addCancelButtonForTarger:self andSelector:NSStringFromSelector(@selector(MBProgressHUDCancelButtonDidPressed))];
}

- (void)startCapturing
{
    if ([[LocationManager sharedManager] isLocationServiceEnabled]) {
        __weak typeof(self) weakSelf = self;
        [[LocationManager sharedManager] checkLocationPermissions:^(BOOL result) {
            if (result) {
                [weakSelf.HUD show:YES];
                [LocationManager sharedManager].delegate = weakSelf;
                [[LocationManager sharedManager] startUpdatingLocation];
            } else {
                [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NoLocationPermissionGranted") delegate:weakSelf otherButtonTitles:dynamicLocalizedString(@"coverageReport.alertButton2.title")];
            }
        }];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NoLocationEnabledOnDevice") delegate:self otherButtonTitles:dynamicLocalizedString(@"coverageReport.alertButton2.title")];
    }
}

@end
