//
//  SuggestionViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SuggestionViewController.h"
#import "NetworkManager.h"
#import "LoginViewController.h"

@interface SuggestionViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *suggestionTitle;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *suggectionDescription;
@property (weak, nonatomic) IBOutlet UIButton *sendSuggestionButton;

@end

@implementation SuggestionViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self presentLoginIfNeededAndPopToRootController:nil];
}

#pragma mark - IABaction

- (IBAction)suggection:(id)sender
{
    [self.view endEditing:YES];
    if (!self.suggestionTitle.text.length || !self.suggectionDescription.text.length){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTSendSuggestion:self.suggestionTitle.text description:self.suggectionDescription.text attachment:self.selectImage requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            }
        }];
    }
}

#pragma mark - Superclass Methods

- (void)selectImageDidLoad
{
//    self.buttonAttachImage = [UIImage imageNamed:@"ic_ml"];
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

@end