//
//  CompliantViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CompliantViewController.h"
#import "NetworkManager.h"

@interface CompliantViewController ()

@property (weak, nonatomic) IBOutlet UITextField *providerText;
@property (weak, nonatomic) IBOutlet UITextField *compliantTitle;
@property (weak, nonatomic) IBOutlet UITextField *refNumber;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UITextView *compliantDescriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceTitleTextFieldConstraint;

@end

@implementation CompliantViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUI];
    self.title = @"Compliant";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.providerText becomeFirstResponder];
    
    [self updateUIForCompliantType:self.type];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateColors];
}

#pragma mark - IABaction

- (IBAction)selectImage:(id)sender
{
    [self selectImagePickerController];
}

- (IBAction)compliant:(id)sender
{
    [self.view endEditing:YES];
    if (!self.compliantDescriptionTextView.text.length ||
        !self.compliantTitle.text.length ||
        (self.type == ComplianTypeCustomProvider && (!self.providerText.text.length || !self.refNumber.text.length))){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTComplianAboutServiceProvider:self.providerText.text title:self.compliantTitle.text description:self.compliantDescriptionTextView.text refNumber:[self.refNumber.text integerValue] attachment:self.selectImage complienType:self.type requestResult:^(id response, NSError *error) {
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
    
    self.compliantDescriptionTextView.layer.cornerRadius = 8;
    self.compliantDescriptionTextView.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
    self.compliantDescriptionTextView.layer.borderWidth = 1;
}

- (void)updateColors
{
    self.compliantDescriptionTextView.textColor = [[DynamicUIService service] currentApplicationColor];
    self.compliantDescriptionTextView.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
    
    [self prepareUI];
}

- (void)updateUIForCompliantType:(ComplianType)type
{
    switch (type) {
        case ComplianTypeCustomProvider: {
            self.providerText.hidden = NO;
            self.refNumber.hidden = NO;
            self.verticalSpaceTitleTextFieldConstraint.constant = 64.f;
            break;
        }
        case ComplianTypeEnquires:
        case ComplianTypeTRAService: {
            self.verticalSpaceTitleTextFieldConstraint.constant = 16.f;
            break;
        }
            
        default:
            break;
    }
}

@end
