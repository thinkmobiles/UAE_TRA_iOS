//
//  SuggestionViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SuggestionViewController.h"
#import "NetworkManager.h"

@interface SuggestionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *suggestionTitle;
@property (weak, nonatomic) IBOutlet UITextField *suggectionDescription;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;

@end

@implementation SuggestionViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUI];
    self.title = @"Send suggestion";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.suggestionTitle becomeFirstResponder];
}

#pragma mark - IABaction

- (IBAction)selectImage:(id)sender
{
    [self selectImagePickerController];
}

- (IBAction)suggection:(id)sender
{
    [self.view endEditing:YES];
    if (!self.suggestionTitle.text.length || !self.suggectionDescription.text.length){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTSendSuggestion:self.suggestionTitle.text description:self.suggectionDescription.text attachment:self.selectImage requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
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
}

@end
