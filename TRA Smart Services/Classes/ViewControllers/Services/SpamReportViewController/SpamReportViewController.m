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
#import <MessageUI/MessageUI.h>

static NSInteger const BlockServiceNumber = 7726;

@interface SpamReportViewController () <MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *providerType;

@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UISegmentedControl *reportSegment;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalDescriptionsContreint;

@property (strong, nonatomic) UIPickerView *selectProviderPicker;
@property (strong, nonatomic) NSArray *pickerSelectProviderDataSource;

@end

@implementation SpamReportViewController

#pragma mark - Life Cicle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self presentLoginIfNeeded];
    [self preparePickerDataSource];
    [self configureSelectProviderTextFieldInputView];
}

#pragma mark - IBAction

- (IBAction)responseSpam:(id)sender
{
    [self.view endEditing:YES];
    if (self.reportSegment.selectedSegmentIndex) {
        if (!self.phoneNumber.text.length || !self.notes.text.length) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        } else {
            [self POSTSpamReport];
            [self sendSMSMessage];
        }
    } else {
        if (!self.phoneNumber.text.length || !self.providerType.text.length || !self.notes.text.length) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        } else {
            [self POSTSMSBlock];
            [self sendSMSMessage];
         }
    }
}

- (IBAction)didChangeReportType:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex) {
        self.providerType.hidden = YES;
        [self.reportButton setTitle:dynamicLocalizedString(@"spamReportViewControler.reportSpamButton.title") forState:UIControlStateNormal];
    } else {
        self.providerType.hidden = NO;
        [self.reportButton setTitle:dynamicLocalizedString(@"spamReportViewControler.reportButton.title") forState:UIControlStateNormal];
    }
    
    [self animatinSelectReportType];
    [self clearUp];
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

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger pickerRowsInComponent = 0;
    if (pickerView == self.selectProviderPicker) {
        pickerRowsInComponent = self.pickerSelectProviderDataSource.count;
    }
    return pickerRowsInComponent;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickerTitle = @"";
    if (pickerView == self.selectProviderPicker) {
        pickerTitle = (NSString *)self.pickerSelectProviderDataSource[row];
    }
    return pickerTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.selectProviderPicker) {
        self.providerType.text = self.pickerSelectProviderDataSource[row];
    }
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"spamReportViewControler.title");
    self.phoneNumber.placeholder = dynamicLocalizedString(@"spamReportViewControler.textField.phoneNumber");
    self.providerType.placeholder = dynamicLocalizedString(@"spamReportViewControler.textField.providerType");
    [self.reportButton setTitle:dynamicLocalizedString(@"spamReportViewControler.reportButton.title") forState:UIControlStateNormal];
    [self.reportSegment setTitle:dynamicLocalizedString(@"spamReportViewControler.reportSegment.forSegmentAtIndex0.title") forSegmentAtIndex:0];
    [self.reportSegment setTitle:dynamicLocalizedString(@"spamReportViewControler.reportSegment.forSegmentAtIndex1.title") forSegmentAtIndex:1];
}

- (void)updateColors
{
    [super updateColors];
    
    self.reportSegment.tintColor = [self.dynamicService currentApplicationColor];
    self.notes.layer.borderColor = [self.dynamicService currentApplicationColor].CGColor;
    self.notes.textColor = [self.dynamicService currentApplicationColor];
    [AppHelper setStyleForLayer:self.notes.layer];
}

#pragma mark - Networking

- (void)POSTSpamReport
{
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSSpamReport:self.phoneNumber.text notes:self.notes.text requestResult:^(id response, NSError *error) {
    }];
}

- (void)POSTSMSBlock
{
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSBlock:self.phoneNumber.text phoneProvider:[NSString stringWithFormat:@"%i", (int)BlockServiceNumber] providerType:self.providerType.text notes:self.notes.text requestResult:^(id response, NSError *error) {
    }];
}

#pragma mark - SMSMessage

- (void)sendSMSMessage
{
    if([MFMessageComposeViewController canSendText]) {
        [UINavigationBar appearance].barTintColor = self.dynamicService.currentApplicationColor;
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName : self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:17] : [UIFont latoRegularWithSize:17]};
        
        NSArray *recipents = @[[NSString stringWithFormat:@"%li", BlockServiceNumber]];
        NSString *message = [NSString stringWithFormat:@"b %@", self.phoneNumber.text];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
        [messageController setBody:message];
        [self presentViewController:messageController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
        messageController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.FailedToInitializeMFController")];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultFailed: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.FailedToSendSMS")];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)animatinSelectReportType
{
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.verticalDescriptionsContreint.constant = weakSelf.verticalDescriptionsContreint.constant == 18 ? 65 : 18;
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)preparePickerDataSource
{
    self.pickerSelectProviderDataSource = @[
                                            dynamicLocalizedString(@"providerType.Du"),
                                            dynamicLocalizedString(@"providerType.Etisalat"),
                                            ];
    [self.selectProviderPicker reloadAllComponents];
}

- (void)configureSelectProviderTextFieldInputView
{
    self.selectProviderPicker = [[UIPickerView alloc] init];
    self.selectProviderPicker.delegate = self;
    self.selectProviderPicker.dataSource = self;
    self.providerType.inputView = self.selectProviderPicker;
}

- (void)clearUp
{
    self.providerType.text = @"";
    self.phoneNumber.text = @"";
    self.notes.text = @"";
}

@end