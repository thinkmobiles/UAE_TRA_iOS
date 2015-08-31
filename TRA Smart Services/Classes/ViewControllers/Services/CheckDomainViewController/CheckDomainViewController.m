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

@end

@implementation CheckDomainViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - IBActions

- (IBAction)avaliabilityButtonTapped:(id)sender
{
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        [AppHelper showLoader];
        [self.view endEditing:YES];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainAvaliability:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
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
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
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
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
        } else if ([subView isKindOfClass:[UITextField class]]) {
            ((UITextField *)subView).textColor = [[DynamicUIService service] currentApplicationColor];
        }
        if (![subView isKindOfClass:[UITextView class]]) {
            [AppHelper setStyleForLayer:subView.layer];
        }
    }
}

@end
