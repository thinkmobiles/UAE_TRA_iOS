//
//  RegisterViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "RegisterViewController.h"
#import "TextFieldNavigator.h"

static CGFloat const HeightForToolbars = 44.f;
static CGFloat const HeightTextFieldAndSeparator = 50.f;
static NSInteger const SeparatorTag = 77;

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *registerScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet LeftInsetTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *emiratesIDTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *mobileTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *emailTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *selectStateTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaseRegisterConteinerUIView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollLogoImage;
@property (weak, nonatomic) IBOutlet UIView *registerContainer;

@property (assign, nonatomic) CGFloat offSetTextFildY;
@property (assign, nonatomic) CGFloat keyboardHeight;

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
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
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
        CGFloat lineEventScroll = self.registerScrollView.frame.size.height + self.registerScrollView.contentOffset.y - self.keyboardHeight - 2 * HeightTextFieldAndSeparator + 20.f;

        if (offsetTextField  > lineEventScroll) {
            [self.registerScrollView setContentOffset:CGPointMake(0, self.registerScrollView.contentOffset.y + HeightTextFieldAndSeparator) animated:YES];
        }
        CGFloat offsetForScrollViewY = self.registerScrollView.frame.size.height - self.verticalSpaseRegisterConteinerUIView.constant - self.registerScrollView.contentOffset.y - self.keyboardHeight;
        if (lineEventScroll < self.offSetTextFildY + self.verticalSpaseRegisterConteinerUIView.constant - HeightTextFieldAndSeparator) {
            [self.registerScrollView setContentOffset:CGPointMake(0, self.offSetTextFildY - offsetForScrollViewY - self.registerScrollView.contentOffset.y + HeightTextFieldAndSeparator + 10.f) animated:YES];
        }
    }
    if (textField.returnKeyType == UIReturnKeyDone) {
        CGFloat offsetForScrollViewY = self.registerScrollView.contentSize.height - self.registerScrollView.frame.size.height;
        [self.registerScrollView setContentOffset:CGPointMake(0, offsetForScrollViewY ) animated:YES];
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat selectegStateTextField = 0;
    if (textField.tag == 8) {
        selectegStateTextField = 2 * HeightTextFieldAndSeparator;
    }
    self.offSetTextFildY = textField.frame.origin.y + textField.frame.size.height + selectegStateTextField;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self vizibleTextFieldChangeKeyboard];
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
            [self.scrollLogoImage setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
        }
    } else {
        [self.scrollLogoImage setContentOffset:CGPointMake(0, 0)];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)doneFilteringButtonTapped
{
    [self.selectStateTextField resignFirstResponder];
    CGFloat offsetForScrollViewY = self.registerScrollView.contentSize.height - self.registerScrollView.frame.size.height;
    [self.registerScrollView setContentOffset:CGPointMake(0, offsetForScrollViewY ) animated:YES];
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
    self.keyboardHeight = keyboardRect.size.height;
    [self vizibleTextFieldChangeKeyboard];
}

#pragma mark - Superclass methods


- (void)setLTREuropeUI
{
    [self updateUI:NSTextAlignmentLeft];
}

- (void)setRTLArabicUI
{
    [self updateUI:NSTextAlignmentRight];
}

#pragma mark - Private

- (void)updateUI:(NSTextAlignment)textAlignment
{
    [self configureTextField:self.userNameTextField withImageName:@"ic_user_login"];
    [self configureTextField:self.passwordTextField withImageName:@"ic_pass"];
    [self configureTextField:self.confirmPasswordTextField withImageName:@"ic_pass"];
    [self configureTextField:self.firstNameTextField withImageName:@"ic_user_login"];
    [self configureTextField:self.emiratesIDTextField withImageName:@"ic_id"];
    [self configureTextField:self.lastNameTextField withImageName:@"ic_user_login"];
    [self configureTextField:self.mobileTextField withImageName:@"ic_phone_reg"];
    [self configureTextField:self.emailTextField withImageName:@"ic_mail"];
    [self configureTextField:self.selectStateTextField withImageName:@"ic_state"];

    self.userNameTextField.textAlignment = textAlignment;
    self.passwordTextField.textAlignment = textAlignment;
    self.confirmPasswordTextField.textAlignment = textAlignment;
    self.firstNameTextField.textAlignment = textAlignment;
    self.emiratesIDTextField.textAlignment = textAlignment;
    self.lastNameTextField.textAlignment = textAlignment;
    self.mobileTextField.textAlignment = textAlignment;
    self.emailTextField.textAlignment = textAlignment;
    self.selectStateTextField.textAlignment = textAlignment;
}

- (void) vizibleTextFieldChangeKeyboard
{
    CGFloat offsetForScrollViewY = self.registerScrollView.frame.size.height - self.verticalSpaseRegisterConteinerUIView.constant - self.registerScrollView.contentOffset.y - self.keyboardHeight;
    CGFloat lineEventScroll = self.registerScrollView.frame.size.height + self.registerScrollView.contentOffset.y - self.keyboardHeight - 2 * HeightTextFieldAndSeparator + 20.f;
    if (lineEventScroll < self.offSetTextFildY + self.verticalSpaseRegisterConteinerUIView.constant - HeightTextFieldAndSeparator) {
        [self.registerScrollView setContentOffset:CGPointMake(0, self.offSetTextFildY - offsetForScrollViewY - self.registerScrollView.contentOffset.y + HeightTextFieldAndSeparator + 10.f) animated:YES];
    }
}

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
    [self.registerButton setTitle:dynamicLocalizedString(@"register.button.register") forState:UIControlStateNormal];
    [self.loginButton setTitle:dynamicLocalizedString(@"register.button.login") forState:UIControlStateNormal];
}

- (void)updateColors
{
    [self.loginButton setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
//    [self.registerButton  setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"res_img_bg"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
    
    for (UIView *separator in self.registerContainer.subviews) {
        if (separator.tag == SeparatorTag) {
            separator.backgroundColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
    
    [self.registerButton setBackgroundColor:[[DynamicUIService service] currentApplicationColor]];
    
    self.userNameTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeholderText.username")];
    self.mobileTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.phone")];
    self.passwordTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.password")];
    self.confirmPasswordTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.confirmPassword")];
    self.firstNameTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.firstName")];
    self.lastNameTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.lastName")];
    self.emailTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.email")];
    self.emiratesIDTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.emirateID")];
    self.selectStateTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"state.SelectState")];
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

- (NSAttributedString *)placeholderWithString:(NSString *)string
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[[DynamicUIService service] currentApplicationColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
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

    self.selectStatePicker.backgroundColor = [UIColor clearColor];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HeightForToolbars)];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.tintColor = [[DynamicUIService service] currentApplicationColor];
    
    UIBarButtonItem *barItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneFilteringButtonTapped)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:@[flexibleSpace, barItemDone]];
    
    self.selectStateTextField.inputAccessoryView = toolBar;
}

@end