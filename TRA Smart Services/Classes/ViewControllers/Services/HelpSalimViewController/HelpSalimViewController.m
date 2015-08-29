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

@end

@implementation HelpSalimViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Help Salim Service";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self prepareUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateColors];
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

#pragma mark - Private

- (void)prepareUI
{
    for (UIButton *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.layer.cornerRadius = 8;
            subView.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
            [subView setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
            subView.layer.borderWidth = 1;
        }
    }
    for (UITextField *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            subView.layer.cornerRadius = 8;
            subView.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
            subView.textColor = [[DynamicUIService service] currentApplicationColor];
            subView.layer.borderWidth = 1;
        }
    }
    self.commentTextView.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
    self.commentTextView.layer.borderWidth = 1;
    self.commentTextView.layer.cornerRadius = 8;
    self.commentTextView.textColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)updateColors
{
    for (UILabel *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.textColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    [self prepareUI];
}

@end