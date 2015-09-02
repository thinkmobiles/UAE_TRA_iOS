//
//  CheckDomainViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CheckDomainViewController.h"
#import "ServiceView.h"
#import "UINavigationController+Transparent.h"
#import "UIImage+DrawText.h"
#import "LeftInsetTextField.h"

@interface CheckDomainViewController ()

@property (weak, nonatomic) IBOutlet LeftInsetTextField *domainNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;
@property (weak, nonatomic) IBOutlet UIButton *avaliabilityButton;
@property (weak, nonatomic) IBOutlet UIButton *whoISButton;
@property (weak, nonatomic) IBOutlet UILabel *domainAvaliabilityLabel;

@property (weak, nonatomic) IBOutlet ServiceView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *topHolderView;
@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *domainDataScrollView;

@end

@implementation CheckDomainViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareTopView];
    [self prepareRatingView];
    [self updateNavigationControllerBar];
    [self prepareUI];
    [self displayDataIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.response = nil;
    self.domainAvaliabilityLabel.hidden = YES;
    self.ratingView.hidden = YES;
    self.domainNameTextField.text = @"";
}

#pragma mark - IBActions

- (IBAction)avaliabilityButtonTapped:(id)sender
{
    void (^PresentResult)(NSString *response) = ^(NSString *response) {
        CheckDomainViewController *checkDomainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"verificationID"];
        checkDomainViewController.response = response;
        checkDomainViewController.domainName = self.domainNameTextField.text;
        [self.navigationController pushViewController:checkDomainViewController animated:YES];
    };
    
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        self.domainAvaliabilityLabel.hidden = NO;
        [AppHelper showLoader];
        [self.view endEditing:YES];
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainAvaliability:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                PresentResult(response);
            }
            [AppHelper hideLoader];
        }];
    }
}

- (IBAction)whoIsButtonTapped:(id)sender
{
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        self.domainAvaliabilityLabel.hidden = NO;
        [AppHelper showLoader];
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainData:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                weakSelf.informationTextView.text = response;
            }
            [AppHelper hideLoader];
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - RatingViewDelegate

- (void)ratingChanged:(NSInteger)rating
{
    
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"checkDomainViewController.title");
    self.domainNameTextField.placeholder = dynamicLocalizedString(@"checkDomainViewController.domainNameTextField");
    [self.avaliabilityButton setTitle:dynamicLocalizedString(@"checkDomainViewController.avaliabilityButton.title") forState:UIControlStateNormal];
    [self.whoISButton setTitle:dynamicLocalizedString(@"checkDomainViewController.whoISButton.title") forState:UIControlStateNormal];
    self.serviceView.serviceName.text = dynamicLocalizedString(@"checkDomainViewController.domainTitleForView");
    self.ratingView.chooseRating.text = [dynamicLocalizedString(@"checkDomainViewController.chooseRating") uppercaseString];
}

- (void)updateColors
{
    [super updateColors];
    
    self.ratingView.chooseRating.textColor = [[DynamicUIService service] currentApplicationColor];
    
    UIImage *background = [UIImage imageNamed:@"trimmedBackground"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        background = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:background];
    }
    self.backgroundImageView.image = background;
}

#pragma mark - Private

- (void)prepareTopView
{
    UIImage *logo = [UIImage imageNamed:@"ic_edit_hex"];
    self.serviceView.serviceImage.image = [logo imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.topHolderView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)updateNavigationControllerBar
{
    [self.navigationController presentTransparentNavigationBarAnimated:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)prepareUI
{
    self.domainNameTextField.layer.borderColor = [UIColor lightGrayBorderColor].CGColor;
    self.domainNameTextField.layer.borderWidth = 1.5f;
    self.domainNameTextField.layer.cornerRadius = 3.f;
}

- (void)displayDataIfNeeded
{
    if (self.response.length) {
        self.domainAvaliabilityLabel.hidden = NO;
        self.domainAvaliabilityLabel.text = [self.response uppercaseString];
        self.domainNameTextField.text = self.domainName;
        if ([self.response containsString:@"Not"]) {
            self.domainAvaliabilityLabel.textColor = [UIColor redTextColor];
        } else {
            self.domainAvaliabilityLabel.textColor = [UIColor lightGreenTextColor];
        }
        self.ratingView.hidden = NO;
        self.avaliabilityButton.hidden = YES;
        self.whoISButton.hidden = YES;
    } else if (self.result) {
        
    }
}

- (void)prepareRatingView
{
    self.ratingView.delegate = self;
}

@end
