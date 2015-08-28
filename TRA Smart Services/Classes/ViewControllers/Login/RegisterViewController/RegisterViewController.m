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
@property (weak, nonatomic) IBOutlet OffsetTextField *stateTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLogoImageViewConstraint;

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
    [self prepareLogoImageView];
    [self updateColors];
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
        CGFloat offsetTextField = textField.frame.origin.y + self.logoImageView.frame.size.height;
        
        CGFloat lineEventScroll = self.scrollView.frame.size.height + self.scrollView.contentOffset.y - 216.f - 110.f;
        
        if (offsetTextField  > lineEventScroll) {
            __weak typeof(self) weakSelf = self;
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + 50.f )];
                [weakSelf.view layoutIfNeeded];
            }];
        }
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        CGFloat offsetForScrollViewY = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
        __weak typeof(self) weakSelf = self;
        [self.view layoutIfNeeded];
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
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.PasswordsNotEqual")];
        return;
    }
    if (self.userNameTextField.text.length && self.genderTextField.text.length && self.mobileTextField.text.length && self.passwordTextField.text.length && self.confirmPasswordTextField.text.length && self.firstNameTextField.text.length && self.emiratesIDTextField.text.length && self.lastNameTextField.text.length && self.addressTextField.text.length && self.landlineTextField.text.length && self.countryTextField.text.length && self.emailTextField.text.length) {
        
        if ([self validationFopmatTextField]){
            return;
        }
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSRegisterUsername:self.userNameTextField.text password:self.passwordTextField.text firstName:self.firstNameTextField.text lastName:self.lastNameTextField.text emiratesID:self.emiratesIDTextField.text state:self.stateTextField.text mobilePhone:self.mobileTextField.text email:self.emailTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [response isKindOfClass:[NSString class]] ? [AppHelper alertViewWithMessage:response] : [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
            }
            [AppHelper hideLoader];
        }];

    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    }
}

- (IBAction)loginButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Keyboard

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
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
        CGFloat lineEventScroll = self.scrollView.frame.size.height + self.scrollView.contentOffset.y - keyboardHeight - 110.f;
        if (lineEventScroll < self.offSetTextFildY + self.logoImageView.frame.size.height - 50.f) {
        __weak typeof(self) weakSelf = self;
        [weakSelf.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, self.offSetTextFildY - offsetForScrollViewY - self.scrollView.contentOffset.y + 50.f)];
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Private

- (BOOL)validationFopmatTextField
{
    if (![self.userNameTextField.text isValidUserName]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatUserName")];
        return YES;
    }
    if (![self.firstNameTextField.text isValidName]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatFirstName")];
        return YES;
    }
    if (![self.lastNameTextField.text isValidName]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatLastName")];
        return YES;
    }
    if (![self.emiratesIDTextField.text isValidIDEmirates]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatIDEmirates")];
        return YES;
    }
    if (![self.mobileTextField.text isValidPhoneNumber]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatMobile")];
        return YES;
    }
    if (![self.emailTextField.text isValidEmailUseHardFilter:NO]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatEmail")];
        return YES;
    }
    return NO;
}

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"register.title");
    self.userNameTextField.placeholder = dynamicLocalizedString(@"register.placeholderText.username");
    self.genderTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.gender");
    self.mobileTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.phone");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.password");
    self.confirmPasswordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.confirmPassword");
    self.firstNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.firstName");
    self.emiratesIDTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.emirateID");
    self.lastNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.lastName");
    self.addressTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.address");
    self.landlineTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.landline");
    self.countryTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.country");
    self.emailTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.email");
    self.stateTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.state");
    [self.registerButton setTitle:dynamicLocalizedString(@"register.button.register") forState:UIControlStateNormal];
    [self.loginButton setTitle:dynamicLocalizedString(@"register.button.login") forState:UIControlStateNormal];
}

- (void)updateColors
{
    self.logoImageView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
    [self.registerButton setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    [self.registerButton  setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    self.view.backgroundColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)prepareNavigationBar
{
    self.title = dynamicLocalizedString(@"register.title");
}

- (void)prepareLogoImageView
{
    self.heightLogoImageViewConstraint.constant = 252.f - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y;  //252 - temp while no design provided
}

@end