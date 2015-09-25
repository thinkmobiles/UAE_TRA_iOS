//
//  PostFeedbackViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "PostFeedbackViewController.h"

@interface PostFeedbackViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *ratingTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation PostFeedbackViewController

#pragma mark - IBActions

- (IBAction)sendButtonTapped:(id)sender
{
    if (![self.ratingTextField.text isValidRating]){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.IncorrectRatings")];
        return;
    }
    if (!self.serviceNameTextField.text.length || !self.ratingTextField.text.length || !self.feedbackTextView.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        return;
    }
    TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
    [self.view endEditing:YES];
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTFeedback:self.feedbackTextView.text forSerivce:self.serviceNameTextField.text withRating:[self.ratingTextField.text integerValue] requestResult:^(id response, NSError *error) {
        if (error) {
            [loader setCompletedStatus:TRACompleteStatusFailure withDescription:((NSString *)response).length ? response : error.localizedDescription];
        } else {
            [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
        }
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
    self.title = dynamicLocalizedString(@"postFeedbackViewController.title");
    self.serviceNameTextField.placeholder = dynamicLocalizedString(@"postFeedbackViewController.serviceNameTextField");
    self.ratingTextField.placeholder = dynamicLocalizedString(@"postFeedbackViewController.ratingTextField");
    self.feedbackLabel.text = dynamicLocalizedString(@"postFeedbackViewController.feedbackLabel.text");
    [self.sendButton setTitle:dynamicLocalizedString(@"postFeedbackViewController.sendButton.title")forState:UIControlStateNormal];
}

- (void)updateColors
{
    [super updateColors];
    
    [AppHelper setStyleForLayer:self.feedbackTextView.layer];
    self.feedbackTextView.textColor = [self.dynamicService currentApplicationColor];
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

@end
