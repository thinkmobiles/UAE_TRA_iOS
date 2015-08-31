//
//  CompliantViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CompliantViewController.h"
#import "NetworkManager.h"
#import "LoginViewController.h"

@interface CompliantViewController ()

@property (weak, nonatomic) IBOutlet UITextField *providerText;
@property (weak, nonatomic) IBOutlet UITextField *compliantTitle;
@property (weak, nonatomic) IBOutlet UITextField *refNumber;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *compliantButton;
@property (weak, nonatomic) IBOutlet UITextView *compliantDescriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceTitleTextFieldConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation CompliantViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self updateUIForCompliantType:self.type];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self presentLoginIfNeeded];
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
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
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

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"compliantViewController.title");
    self.providerText.placeholder = dynamicLocalizedString(@"compliantViewController.textField.providerText");
    self.compliantTitle.placeholder = dynamicLocalizedString(@"compliantViewController.textField.compliantTitle");
    self.refNumber.placeholder = dynamicLocalizedString(@"compliantViewController.textField.refNumber");
    self.descriptionLabel.text = dynamicLocalizedString(@"compliantViewController.descriptionLabel.text");
    [self.selectImageButton setTitle:dynamicLocalizedString(@"compliantViewController.selectImageButton.title") forState:UIControlStateNormal];
    [self.compliantButton setTitle:dynamicLocalizedString(@"compliantViewController.compliantButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    self.compliantDescriptionTextView.textColor = [[DynamicUIService service] currentApplicationColor];
    self.compliantDescriptionTextView.layer.borderColor = [[DynamicUIService service] currentApplicationColor].CGColor;
    
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
    
    [AppHelper setStyleForLayer:self.compliantDescriptionTextView.layer];
}

#pragma mark - Private

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

- (void)presentLoginIfNeeded
{
    if (![NetworkManager sharedManager].isUserLoggined) {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
        viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
#endif
        __weak typeof(self) weakSelf = self;
        ((LoginViewController *)viewController.topViewController).didCloseViewController = ^() {
            if (![NetworkManager sharedManager].isUserLoggined) {
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            }
        };
        
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.navigationController presentViewController:viewController animated:NO completion:nil];
    }
}

@end
