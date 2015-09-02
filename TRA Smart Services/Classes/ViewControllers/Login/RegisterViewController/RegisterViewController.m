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
@property (weak, nonatomic) IBOutlet OffsetTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *emiratesIDTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *mobileTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *emailTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *selectStateTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaseRegisterConteinerUIView;

@property (assign, nonatomic) CGFloat offSetTextFildY;

@property (assign, nonatomic) NSInteger selectedState;
@property (strong, nonatomic) NSArray *pickerSelectStateDataSource;
@property (strong, nonatomic) UIPickerView *selectStatePicker;

@end

@implementation RegisterViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.selectedState = -1;
    [self prepareNotification];
    [self prepareRegisterConteinerUIView];
    [self updateColors];
    
    [self configureSelectStateTextFieldInputView];
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
        CGFloat offsetTextField = textField.frame.origin.y + self.verticalSpaseRegisterConteinerUIView.constant;
        
        CGFloat lineEventScroll = self.scrollView.frame.size.height + self.scrollView.contentOffset.y - 216.f - 110.f;
        
        if (offsetTextField  > lineEventScroll) {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + 50.f) animated:YES];
        }
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        CGFloat offsetForScrollViewY = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
        [self.scrollView setContentOffset:CGPointMake(0, offsetForScrollViewY ) animated:YES];
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.offSetTextFildY = textField.frame.origin.y + textField.frame.size.height;
    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger pickerRowsInComponent = 0;
    if (pickerView == self.selectStatePicker) {
        pickerRowsInComponent = self.pickerSelectStateDataSource.count;
    }
    return pickerRowsInComponent;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickerTitle = @"";
    if (pickerView == self.selectStatePicker) {
        pickerTitle = (NSString *)self.pickerSelectStateDataSource[row];
    }
    return pickerTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.selectStatePicker) {
        self.selectStateTextField.text = self.pickerSelectStateDataSource[row];
        self.selectedState = row;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0) {
        if (self.verticalSpaseRegisterConteinerUIView.constant >= scrollView.contentOffset.y) {
            CGRect logoImageFrame = self.logoImageView.frame;
            logoImageFrame.origin.y = - scrollView.contentOffset.y;
            self.logoImageView.frame = logoImageFrame;
        }
    } else {
        CGRect logoImageFrame = self.logoImageView.frame;
        logoImageFrame.origin.y = 0;
        self.logoImageView.frame = logoImageFrame;
    }
}

#pragma mark - IBActions

- (IBAction)registerButtonPress:(id)sender
{
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.PasswordsNotEqual")];
        return;
    }
    if (self.userNameTextField.text.length && self.mobileTextField.text.length && self.passwordTextField.text.length && self.confirmPasswordTextField.text.length && self.firstNameTextField.text.length && self.emiratesIDTextField.text.length && self.lastNameTextField.text.length && self.emailTextField.text.length && self.selectStateTextField.text.length) {
        
        if ([self isInputParametersInvalid]){
            return;
        }
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSRegisterUsername:self.userNameTextField.text
                                                     password:self.passwordTextField.text
                                                    firstName:self.firstNameTextField.text
                                                     lastName:self.lastNameTextField.text
                                                   emiratesID:self.emiratesIDTextField.text
                                                        state:[NSString stringWithFormat:@"%i", (int)self.selectedState]
                                                  mobilePhone:self.mobileTextField.text
                                                        email:self.emailTextField.text requestResult:^(id response, NSError *error) {
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
    CGFloat offsetForScrollViewY = self.scrollView.frame.size.height - self.verticalSpaseRegisterConteinerUIView.constant - self.scrollView.contentOffset.y - keyboardHeight;
        CGFloat lineEventScroll = self.scrollView.frame.size.height + self.scrollView.contentOffset.y - keyboardHeight - 110.f;
        if (lineEventScroll < self.offSetTextFildY + self.verticalSpaseRegisterConteinerUIView.constant - 50.f) {
        [self.scrollView setContentOffset:CGPointMake(0, self.offSetTextFildY - offsetForScrollViewY - self.scrollView.contentOffset.y + 50.f) animated:YES];

    }
}

#pragma mark - Private

- (BOOL)isInputParametersInvalid
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
    if (self.selectedState <= 0) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidStateCode")];
        return YES;
    }
    
    return NO;
}

- (void)localizeUI
{
    [self preparePickerDataSource];
    
    self.title = dynamicLocalizedString(@"register.title");
    self.userNameTextField.placeholder = dynamicLocalizedString(@"register.placeholderText.username");
    self.mobileTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.phone");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.password");
    self.confirmPasswordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.confirmPassword");
    self.firstNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.firstName");
    self.lastNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.lastName");
    self.emailTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.email");
    self.emiratesIDTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.emirateID");
    self.selectStateTextField.placeholder = dynamicLocalizedString(@"state.SelectState");
    [self.registerButton setTitle:dynamicLocalizedString(@"register.button.register") forState:UIControlStateNormal];
    [self.loginButton setTitle:dynamicLocalizedString(@"register.button.login") forState:UIControlStateNormal];
}

- (void)updateColors
{
    self.logoImageView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
    [self.registerButton setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    [self.registerButton  setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
}

- (void)preparePickerDataSource
{
    self.pickerSelectStateDataSource = @[
                                         dynamicLocalizedString(@"state.Abu.Dhabi"),
                                         dynamicLocalizedString(@"state.Ajman"),
                                         dynamicLocalizedString(@"state.Dubai"),
                                         dynamicLocalizedString(@"state.Fujairah"),
                                         dynamicLocalizedString(@"state.Ras"),
                                         dynamicLocalizedString(@"state.Sharjan"),
                                         dynamicLocalizedString(@"state.Quwain")
                                         ];
    [self.selectStatePicker reloadAllComponents];
}

- (void)prepareNavigationBar
{
    self.title = dynamicLocalizedString(@"register.title");
}

- (void)prepareRegisterConteinerUIView
{
    self.verticalSpaseRegisterConteinerUIView.constant = self.logoImageView.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y;
}

- (void)configureSelectStateTextFieldInputView
{
    self.selectStatePicker = [[UIPickerView alloc] init];
    self.selectStatePicker.delegate = self;
    self.selectStatePicker.dataSource = self;
    self.selectStateTextField.inputView = self.selectStatePicker;
}


@end