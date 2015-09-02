//
//  CheckDomainViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CheckDomainViewController.h"

@interface CheckDomainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *domainNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;
@property (weak, nonatomic) IBOutlet UIButton *avaliabilityButton;
@property (weak, nonatomic) IBOutlet UIButton *whoISButton;
@property (weak, nonatomic) IBOutlet UILabel *domainAvaliabilityLabel;

@end

@implementation CheckDomainViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.domainNameTextField.layer.borderColor = [UIColor lightGrayBorderColor].CGColor;
    self.domainNameTextField.layer.borderWidth = 1.5f;
    self.domainNameTextField.layer.cornerRadius = 3.f;
}

#pragma mark - IBActions

- (IBAction)avaliabilityButtonTapped:(id)sender
{
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        self.domainAvaliabilityLabel.hidden = NO;
        [AppHelper showLoader];
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainAvaliability:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                weakSelf.domainAvaliabilityLabel.hidden = NO;
                weakSelf.domainAvaliabilityLabel.text = [response uppercaseString];
                if ([response containsString:@"Not"]) {
                    weakSelf.domainAvaliabilityLabel.textColor = [UIColor redTextColor];
                } else {
                    weakSelf.domainAvaliabilityLabel.textColor = [UIColor lightGreenTextColor];
                }
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

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"checkDomainViewController.title");
    self.domainNameTextField.placeholder = dynamicLocalizedString(@"checkDomainViewController.domainNameTextField");
    [self.avaliabilityButton setTitle:dynamicLocalizedString(@"checkDomainViewController.avaliabilityButton.title") forState:UIControlStateNormal];
    [self.whoISButton setTitle:dynamicLocalizedString(@"checkDomainViewController.whoISButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    [super updateColors];
}

@end
