//
//  RegisterViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "RegisterViewController.h"
#import "TextFieldNavigator.h"

@interface RegisterViewController ()


@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet OffsetTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *genderTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *emiratesIDTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *addressTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *landlineTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *countryTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *mobileTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (assign, nonatomic) CGFloat offSetTextFildY;

@end

@implementation RegisterViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareNotification];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [TextFieldNavigator findNextTextFieldFromCurrent:textField];

    if (textField.returnKeyType == UIReturnKeyNext) {
        CGFloat offsetForScrollViewY = ((CGFloat) textField.tag + 1) * 50.f;
        if (self.scrollView.contentOffset.y > offsetForScrollViewY ) {
            offsetForScrollViewY = self.scrollView.contentOffset.y;
        }
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetForScrollViewY )];
            [weakSelf.view layoutIfNeeded];
        }];
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        CGFloat offsetForScrollViewY = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, offsetForScrollViewY )];
            [weakSelf.view layoutIfNeeded];
        }];
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.offSetTextFildY = textField.frame.origin.y + textField.frame.size.height;
    return YES;
}

#pragma mark - IBActions

- (IBAction)registerButtonPress:(id)sender
{
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Passwords no equal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.userNameTextField.text.length && self.genderTextField.text.length && self.mobileTextField.text.length && self.passwordTextField.text.length && self.confirmPasswordTextField.text.length && self.firstNameTextField.text.length && self.emiratesIDTextField.text.length && self.lastNameTextField.text.length && self.addressTextField.text.length && self.landlineTextField.text.length && self.countryTextField.text.length && self.emailTextField.text.length) {
        [AppHelper showLoader];
        __weak typeof(self) weakSelf = self;
        
        [[NetworkManager sharedManager] traSSRegisterUsername:self.userNameTextField.text password:self.passwordTextField.text gender:self.genderTextField.text phoneNumber:self.mobileTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:response];
            }
            weakSelf.userNameTextField.text = @"";
            weakSelf.genderTextField.text = @"";
            weakSelf.mobileTextField.text = @"";
            weakSelf.passwordTextField.text = @"";
            weakSelf.confirmPasswordTextField.text = @"";
            weakSelf.firstNameTextField.text = @"";
            weakSelf.emiratesIDTextField.text = @"";
            weakSelf.lastNameTextField.text = @"";
            weakSelf.addressTextField.text = @"";
            weakSelf.landlineTextField.text = @"";
            weakSelf.countryTextField.text = @"";
            weakSelf.emailTextField.text = @"";
            
            [AppHelper hideLoader];
        }];
    } else {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    }
}

- (IBAction)loginButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"register.title");
    self.userNameTextField.placeholder = dynamicLocalizedString(@"register.placeholderText.username");
    self.genderTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.gender");
    self.mobileTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.phone");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.password");
    self.confirmPasswordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.confirmPassword");
    self.firstNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.firstName");
    self.emiratesIDTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.emiratesID");
    self.lastNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.lastName");
    self.addressTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.address");
    self.landlineTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.landline");
    self.countryTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.country");
    self.emailTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.email");
    self.stateLabel.text = dynamicLocalizedString(@"register.placeHolderText.state");
    [self.registerButton setTitle:dynamicLocalizedString(@"register.button.register") forState:UIControlStateNormal];
    [self.loginButton setTitle:dynamicLocalizedString(@"register.button.login") forState:UIControlStateNormal];
}

- (void)updateColors
{
    
}

- (void)prepareNavigationBar
{
    self.title = dynamicLocalizedString(@"register.title");
}

#pragma mark - Keyboard

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    CGFloat offsetForScrollViewY = self.scrollView.frame.size.height - self.logoImageView.frame.size.height - self.scrollView.contentOffset.y - keyboardHeight;
    
     if (offsetForScrollViewY <= self.offSetTextFildY ) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, self.offSetTextFildY - offsetForScrollViewY - self.scrollView.contentOffset.y + 75.f)];
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

@end