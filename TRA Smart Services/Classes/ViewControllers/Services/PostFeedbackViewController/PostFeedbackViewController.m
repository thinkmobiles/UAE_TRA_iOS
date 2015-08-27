//
//  PostFeedbackViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "PostFeedbackViewController.h"

@interface PostFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ratingTextField;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation PostFeedbackViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Post Feedback";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self prepareUI];
}

#pragma mark - IBActions

- (IBAction)sendButtonTapped:(id)sender
{
    if (![self isNSStringIsValid:self.ratingTextField.text]){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.IncorrectRatings")];
        return;
    }
    if (!self.serviceNameTextField.text.length || !self.ratingTextField.text.length || !self.feedbackTextView.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        return;
    }
    [AppHelper showLoader];
    [self.view endEditing:YES];
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTFeedback:self.feedbackTextView.text forSerivce:self.serviceNameTextField.text withRating:[self.ratingTextField.text integerValue] requestResult:^(id response, NSError *error) {
        if (error) {
            [AppHelper alertViewWithMessage:error.localizedDescription];
        } else {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
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
    self.feedbackTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.feedbackTextView.layer.borderWidth = 1;
    self.feedbackTextView.layer.cornerRadius = 8;
}

- (BOOL)isNSStringIsValid:(NSString *)stringToCheck
{
    NSString *stricterFilterString = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [predicate evaluateWithObject:stringToCheck];
}


@end
