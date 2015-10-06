//
//  SuggestionViewController.m
//  TRA Smart Services
//
//  Created by Admin on 14.08.15.
//

#import "SuggestionViewController.h"
#import "LoginViewController.h"
#import "PlaceholderTextView.h"

@interface SuggestionViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *suggestionTitle;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *suggectionDescription;
@property (weak, nonatomic) IBOutlet UIButton *sendSuggestionButton;

@end

@implementation SuggestionViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addAttachButtonTextField:self.suggestionTitle];
    [self presentLoginIfNeededAndPopToRootController:nil];
    [self configureKeyboardButtonDone:self.suggectionDescription];
}

#pragma mark - IABaction

- (IBAction)suggection:(id)sender
{
    [self.view endEditing:YES];
    if (!self.suggestionTitle.text.length || !self.suggectionDescription.text.length){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTSendSuggestion:self.suggestionTitle.text description:self.suggectionDescription.text attachment:self.selectImage requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
            } else {
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
                [weakSelf clearUI];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TRAAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                loader.ratingView.hidden = NO;
            });
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"suggestionViewController.title");
    self.suggestionTitle.placeholder = dynamicLocalizedString(@"suggestionViewController.textField.suggestionTitle");
    self.suggectionDescription.placeholder = dynamicLocalizedString(@"suggestionViewController.textField.suggestionDescription");
    [self.sendSuggestionButton setTitle:dynamicLocalizedString(@"suggestionViewController.sendSuggestionButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

- (void)setRTLArabicUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];
}

#pragma mark - Private

- (void)clearUI
{
    self.suggectionDescription.text = @"";
    self.suggestionTitle.text = @"";
    self.selectImage = nil;
}

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.suggectionDescription.textAlignment = alignment;
    self.suggestionTitle.textAlignment = alignment;
}

@end