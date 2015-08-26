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

@end

@implementation CheckDomainViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUI];
    self.title = @"Domain check";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - IBActions

- (IBAction)avaliabilityButtonTapped:(id)sender
{
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    } else {
        [AppHelper showLoader];
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainAvaliability:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                weakSelf.informationTextView.text = response;
            }
            [AppHelper hideLoader];
        }];
    }
}

- (IBAction)whoIsButtonTapped:(id)sender
{
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    } else {
        [AppHelper showLoader];
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainData:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
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
