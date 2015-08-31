//
//  HelpSalimViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "HelpSalimViewController.h"

@interface HelpSalimViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlToReportTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *reportURLButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation HelpSalimViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

#pragma mark - IBActions

- (IBAction)reportURlButtonTapped:(id)sender
{
    if (!self.urlToReportTextField.text.length || !self.commentTextView.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        return;
    }
    if (![self.urlToReportTextField.text isValidURL]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatURL")];
        return;
    }
    [AppHelper showLoader];
    [self.view endEditing:YES];
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTHelpSalim:self.urlToReportTextField.text notes:self.commentTextView.text requestResult:^(id response, NSError *error) {
        if (error) {
            [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
        } else {
            [AppHelper alertViewWithMessage:response];
        }
        
        [AppHelper hideLoader];
    }];
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
    self.title = dynamicLocalizedString(@"helpSalimViewController.title");
    self.urlToReportTextField.placeholder = dynamicLocalizedString(@"helpSalimViewController.urlToReportTextField");
    self.commentLabel.text = dynamicLocalizedString(@"helpSalimViewController.commentLabel.text");
    [self.reportURLButton setTitle:dynamicLocalizedString(@"helpSalimViewController.reportURLButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
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
    [AppHelper setStyleForLayer:self.commentTextView.layer];
    self.commentTextView.textColor = [[DynamicUIService service] currentApplicationColor];
}

@end