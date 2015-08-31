//
//  SpamRaportViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SpamReportViewController.h"
#import "NetworkManager.h"
#import "LoginViewController.h"

@interface SpamReportViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneProvider;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *providerType;

@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UISegmentedControl *reportSegment;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@end

@implementation SpamReportViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self presentLoginIfNeeded];
}

#pragma mark - IBAction

- (IBAction)responseSpam:(id)sender
{
    [self.view endEditing:YES];
    if (!self.reportSegment.selectedSegmentIndex) {
        if (!self.phoneNumber.text.length || !self.notes.text.length) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        } else {
            [self POSTSpamReport];
        }
    } else {
        if (!self.phoneProvider.text.length || !self.phoneNumber.text.length || !self.providerType.text.length || !self.notes.text.length) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        } else {
            if (![self.phoneNumber.text isValidPhoneNumber]) {
                [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatMobile")];
                return;
            }
            [self POSTSMSBlock];
        }
    }
}

- (IBAction)didChangeReportType:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex) {
        self.providerType.enabled = NO;
        self.phoneProvider.enabled = NO;
        [self.reportButton setTitle:@"Report SMS Spam" forState:UIControlStateNormal];
    } else {
        self.providerType.enabled = YES;
        self.phoneProvider.enabled = YES;
        [self.reportButton setTitle:@"Block SMS Spamer" forState:UIControlStateNormal];
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
    self.title = dynamicLocalizedString(@"spamReportViewControler.title");
    self.phoneProvider.placeholder = dynamicLocalizedString(@"spamReportViewControler.textField.phoneProvider");
    self.phoneNumber.placeholder = dynamicLocalizedString(@"spamReportViewControler.textField.phoneNumber");
    self.providerType.placeholder = dynamicLocalizedString(@"spamReportViewControler.textField.providerType");
    [self.reportButton setTitle:dynamicLocalizedString(@"spamReportViewControler.reportButton.title") forState:UIControlStateNormal];
    [self.reportSegment setTitle:dynamicLocalizedString(@"spamReportViewControler.reportSegment.forSegmentAtIndex0.title") forSegmentAtIndex:0];
    [self.reportSegment setTitle:dynamicLocalizedString(@"spamReportViewControler.reportSegment.forSegmentAtIndex1.title") forSegmentAtIndex:1];
}

- (void)updateColors
{
    self.reportSegment.tintColor = [[DynamicUIService service] currentApplicationColor];
    self.notes.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
    self.notes.textColor = [[DynamicUIService service] currentApplicationColor];
    
    for (UILabel *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.textColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [AppHelper setStyleForLayer:subView.layer];
            [(UIButton *)subView setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
        } else if ([subView isKindOfClass:[UITextField class]]) {
            [AppHelper setStyleForLayer:subView.layer];
            ((UITextField *)subView).textColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    [AppHelper setStyleForLayer:self.notes.layer];
}

- (void)presentLoginIfNeeded
{
    if (![NetworkManager sharedManager].isUserLoggined) {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
        viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
#endif
        __weak typeof(self) weakSelf = self;
        ((LoginViewController *)viewController.topViewController).didCloseViewController = ^() {
            if (![NetworkManager sharedManager].isUserLoggined) {
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            }
        };
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.navigationController presentViewController:viewController animated:NO completion:nil];
    }
}

#pragma mark - Networking

- (void)POSTSpamReport
{
    if (![self.phoneNumber.text isValidPhoneNumber]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatMobile")];
        return;
    }
    [AppHelper showLoader];
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSSpamReport:self.phoneNumber.text notes:self.notes.text requestResult:^(id response, NSError *error) {
        if (error) {
            [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
        } else {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
        }
        [AppHelper hideLoader];
    }];
}

- (void)POSTSMSBlock
{
    [AppHelper showLoader];
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSBlock:self.phoneNumber.text phoneProvider:self.phoneProvider.text providerType:self.providerType.text notes:self.notes.text requestResult:^(id response, NSError *error) {
        if (error) {
            [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
        } else {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
        }
        [AppHelper hideLoader];
    }];
}

@end
