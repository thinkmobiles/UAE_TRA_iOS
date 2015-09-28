//
//  VerificationIMEIViewController.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 17.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "VerificationIMEIViewController.h"
#import "ServiceHeaderView.h"

@interface VerificationIMEIViewController()

@property (weak, nonatomic) IBOutlet ServiceHeaderView *conteinerServiseHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *verificationIMEITextField;
@property (weak, nonatomic) IBOutlet UILabel *verificationIMEIInfoEnterLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendIMEICodeButton;
@property (weak, nonatomic) IBOutlet UILabel *sendIMEICodeLabel;

@end

@implementation VerificationIMEIViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self prepareServiseHeaderView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.title = @" ";
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"verificationIMEIViewController.title");
    self.verificationIMEITextField.placeholder = dynamicLocalizedString(@"verificationIMEIViewController.verificationIMEITextField.placeholder");;
    self.verificationIMEIInfoEnterLabel.text = dynamicLocalizedString(@"verificationIMEIViewController.verificationIMEIInfoEnterLabel");;
    self.sendIMEICodeLabel.text = dynamicLocalizedString(@"verificationIMEIViewController.sendIMEICodeLabel");
}

- (void)updateColors
{
    [self.conteinerServiseHeaderView updateUIColor];
}

#pragma mark - Private

- (void)prepareServiseHeaderView
{
    self.conteinerServiseHeaderView.serviceHeaderLabel.text = dynamicLocalizedString(@"verificationIMEIViewController.serviceHeaderLabel");
    self.conteinerServiseHeaderView.serviceHeaderLabel.textColor = [UIColor blackColor];
    self.conteinerServiseHeaderView.serviceHeaderLabel.font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:16] : [UIFont latoRegularWithSize:16];
    self.conteinerServiseHeaderView.serviceHeaderImage = [UIImage imageNamed:@"ic_edit_hex"];
}

@end