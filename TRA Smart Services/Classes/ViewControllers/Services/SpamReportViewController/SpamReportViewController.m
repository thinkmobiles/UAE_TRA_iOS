//
//  SpamRaportViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SpamReportViewController.h"
#import "NetworkManager.h"

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

    [self.phoneProvider becomeFirstResponder];
    
    [self prepareUI];
    self.title = @"SMS Spam Report";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - IABaction

- (IBAction)responseSpam:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.reportSegment.selectedSegmentIndex) {
        if (!self.phoneNumber.text.length || !self.notes.text.length) {
            [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
        } else {
            [AppHelper showLoader];
            __weak typeof(self) weakSelf = self;
            [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSSpamReport:self.phoneNumber.text notes:self.notes.text requestResult:^(id response, NSError *error) {
                if (error) {
                    [AppHelper alertViewWithMessage:error.localizedDescription];
                } else {
                    [AppHelper alertViewWithMessage:MessageSuccess];
                }
                [AppHelper hideLoader];
                [weakSelf refreshControls];
            }];
        }
    } else {
        if (!self.phoneProvider.text.length || !self.phoneNumber.text.length || !self.providerType.text.length || !self.notes.text.length) {
            [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
        } else {
            [AppHelper showLoader];
            __weak typeof(self) weakSelf = self;
            [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSBlock:self.phoneNumber.text phoneProvider:self.phoneProvider.text providerType:self.providerType.text notes:self.notes.text requestResult:^(id response, NSError *error) {
                if (error) {
                    [AppHelper alertViewWithMessage:error.localizedDescription];
                } else {
                    [AppHelper alertViewWithMessage:MessageSuccess];
                }
                [AppHelper hideLoader];
                [weakSelf refreshControls];
            }];
        }
    }
}

- (void)refreshControls
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.providerType.text = @"";
        self.notes.text = @"";
        self.phoneNumber.text = @"";
        self.phoneProvider.text = @"";
    });
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
    if (textField.returnKeyType == UIReturnKeyNext) {
        UITextField *nextTextField = (UITextField *)[self.view viewWithTag: (textField.tag + 1)];
        [nextTextField becomeFirstResponder];
    }
    return NO;
}

#pragma mark - Private

- (void)prepareUIForTextView
{
    self.notes.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.notes.layer.cornerRadius = 8;
    self.notes.layer.borderWidth = 1;
}

- (void)prepareUI
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.layer.cornerRadius = 8;
            subView.layer.borderColor = [UIColor defaultOrangeColor].CGColor;
            subView.layer.borderWidth = 1;
        }
    }
    [self prepareUIForTextView];
}


@end
