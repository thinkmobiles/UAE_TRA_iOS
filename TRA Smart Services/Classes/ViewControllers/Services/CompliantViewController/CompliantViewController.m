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

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentProvider;
@property (weak, nonatomic) IBOutlet UITextField *providerText;
@property (weak, nonatomic) IBOutlet UITextField *compliantTitle;
@property (weak, nonatomic) IBOutlet UITextField *refNumber;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UITextView *compliantDescriptionTextView;

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
}

#pragma mark - IABaction

- (IBAction)selectImage:(id)sender
{
    [self selectImagePickerController];
}

- (IBAction)segmentProvider:(id)sender
{
    switch (self.segmentProvider.selectedSegmentIndex) {
        case 0:{
            self.providerText.enabled = YES;
            self.refNumber.enabled = YES;
            break;
        }
        default:{
            self.providerText.enabled = NO;
            self.refNumber.enabled = NO;
            self.providerText.text = @"";
            self.refNumber.text = @"";
            break;
        }
    }
}

- (IBAction)compliant:(id)sender
{
    [self.view endEditing:YES];
    if (!self.compliantDescriptionTextView.text.length ||
        !self.compliantTitle.text.length ||
        (!self.segmentProvider.selectedSegmentIndex && (!self.providerText.text.length || !self.refNumber.text.length))){
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    } else {
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTComplianAboutServiceProvider:self.providerText.text title:self.compliantTitle.text description:self.compliantDescriptionTextView.text refNumber:[self.refNumber.text integerValue] attachment:self.selectImage complienType:(ComplianType)self.segmentProvider.selectedSegmentIndex requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:MessageSuccess];
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
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.layer.cornerRadius = 8;
            subView.layer.borderColor = [UIColor defaultOrangeColor].CGColor;
            subView.layer.borderWidth = 1;
        }
    }
    
    self.compliantDescriptionTextView.layer.cornerRadius = 8;
    self.compliantDescriptionTextView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    self.compliantDescriptionTextView.layer.borderWidth = 1;
}

@end
