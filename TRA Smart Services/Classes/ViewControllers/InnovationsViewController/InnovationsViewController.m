//
//  InnovationsViewController.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

#import "InnovationsViewController.h"
#import "PlaceholderTextView.h"

@interface InnovationsViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *innovationsTitleTextField;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation InnovationsViewController

#pragma mark - IBAction

- (IBAction)sendInfo:(id)sender
{
    if (!self.innovationsTitleTextField.text.length || !self.descriptionTextView.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TRAAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
        });
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
    self.title = dynamicLocalizedString(@"innovationsViewController.title");
    [self.submitButton setTitle:dynamicLocalizedString(@"innovationsViewController.submitButton") forState:UIControlStateNormal];
    self.innovationsTitleTextField.placeholder = dynamicLocalizedString(@"innovationsViewController.innovationsTitleTextField.placeholder");
    self.descriptionTextView.placeholder = dynamicLocalizedString(@"innovationsViewController.descriptionTextView.placeholder");
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"fav_back_orange"];
}

- (void)setRTLArabicUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];\
}

#pragma mark - Private

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.innovationsTitleTextField.textAlignment = alignment;
    self.descriptionTextView.textAlignment = alignment;
}

@end
