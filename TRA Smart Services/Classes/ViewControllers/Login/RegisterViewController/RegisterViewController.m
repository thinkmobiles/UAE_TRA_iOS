//
//  RegisterViewController.m
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#import "RegisterViewController.h"
#import "TextFieldNavigator.h"

static CGFloat const HeightTextFieldAndSeparator = 50.f;
static NSInteger const SeparatorTag = 77;

static NSString *const DividerForID = @"-";

@interface RegisterViewController ()

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaseRegisterConteinerUIView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollLogoImage;
@property (weak, nonatomic) IBOutlet UIView *registerContainer;

@property (assign, nonatomic) CGFloat offSetTextFildY;
@property (assign, nonatomic) CGFloat keyboardHeight;

@end

@implementation RegisterViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareRegisterConteinerUIView];
    [self updateColors];
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.emiratesIDTextField.subDelegate = self;
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
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
    if (textField.tag == 7) {
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= 0) {
            [self.scrollLogoImage setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
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
    if (self.userNameTextField.text.length && self.mobileTextField.text.length && self.passwordTextField.text.length && self.confirmPasswordTextField.text.length && self.firstNameTextField.text.length && self.emiratesIDTextField.text.length && self.lastNameTextField.text.length && self.emailTextField.text.length) {
        
        if ([self isInputParametersInvalid]){
            return;
        }
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSRegisterUsername:self.userNameTextField.text
                                                     password:self.passwordTextField.text
                                                    firstName:self.firstNameTextField.text
                                                     lastName:self.lastNameTextField.text
                                                   emiratesID:self.emiratesIDTextField.text
                                                        state:[NSString stringWithFormat:@"%i", 1]
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
    [self.mobileTextField becomeFirstResponder];
}

- (IBAction)didChangeEmiratesID:(UITextField *)sender
{
    [self prepareEmiratesIDWithTextField:sender];
}

#pragma mark - LeftInsetTextFieldDelegate

- (void)textFieldDidDelete:(UITextField *)textField
{
    if ((textField.text.length == 4 || textField.text.length == 9 || textField.text.length == 17) && textField.tag == 6){
        NSString *phone = [textField.text substringToIndex:textField.text.length - 1];
        textField.text = phone;
    }
}

#pragma mark - Keyboard

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

    self.userNameTextField.textAlignment = textAlignment;
    self.passwordTextField.textAlignment = textAlignment;
    self.confirmPasswordTextField.textAlignment = textAlignment;
    self.firstNameTextField.textAlignment = textAlignment;
    self.emiratesIDTextField.textAlignment = textAlignment;
    self.lastNameTextField.textAlignment = textAlignment;
    self.mobileTextField.textAlignment = textAlignment;
    self.emailTextField.textAlignment = textAlignment;
}

- (void)vizibleTextFieldChangeKeyboard
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
    if (![[self.emiratesIDTextField.text stringByReplacingOccurrencesOfString:DividerForID withString:@""] isValidIDEmirates]) {
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
    [self.registerButton setTitle:dynamicLocalizedString(@"register.button.register") forState:UIControlStateNormal];
    [self.loginButton setTitle:dynamicLocalizedString(@"register.button.login") forState:UIControlStateNormal];
}

- (void)updateColors
{
    UIColor *color = [self.dynamicService currentApplicationColor];
    [self.loginButton setTitleColor:color forState:UIControlStateNormal];
    [super updateBackgroundImageNamed:@"res_img_bg"];
    
    for (UIView *separator in self.registerContainer.subviews) {
        if (separator.tag == SeparatorTag) {
            separator.backgroundColor = color;
        }
    }
    
    [self.registerButton setBackgroundColor:[self.dynamicService currentApplicationColor]];
    
    self.userNameTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeholderText.username")];
    self.mobileTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.phone")];
    self.passwordTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.password")];
    self.confirmPasswordTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.confirmPassword")];
    self.firstNameTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.firstName")];
    self.lastNameTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.lastName")];
    self.emailTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.email")];
    self.emiratesIDTextField.attributedPlaceholder = [self placeholderWithString:dynamicLocalizedString(@"register.placeHolderText.emirateID")];
    
    self.userNameTextField.textColor = color;
    self.mobileTextField.textColor = color;
    self.passwordTextField.textColor = color;
    self.confirmPasswordTextField.textColor = color;
    self.firstNameTextField.textColor = color;
    self.lastNameTextField.textColor = color;
    self.emailTextField.textColor = color;
    self.emiratesIDTextField.textColor = color;
}

- (NSAttributedString *)placeholderWithString:(NSString *)string
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[self.dynamicService currentApplicationColor]};
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

- (void)prepareRegisterConteinerUIView
{
    self.verticalSpaseRegisterConteinerUIView.constant = self.logoImageView.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y;
}

#pragma mark - TextFieldCalculations

- (void)prepareEmiratesIDWithTextField:(UITextField *)textField
{
    if (textField.text.length == 3 || textField.text.length == 8 || textField.text.length == 16) {
        NSString *textToShow = [textField.text stringByAppendingString:DividerForID];
        textField.text = textToShow;
    }
    if (textField.text.length >= 18) {
        NSString *phone = [textField.text substringToIndex:18];
        textField.text = phone;
    }
    
    if ((textField.text.length == 4 && ([textField.text rangeOfString:DividerForID].location == NSNotFound))) {
        NSString *firstPart = [textField.text substringToIndex:3];
        firstPart = [[firstPart stringByAppendingString:DividerForID] stringByAppendingString:[textField.text substringFromIndex:3]];
        textField.text = firstPart;
    } else if ((textField.text.length == 9 && [[textField.text substringFromIndex:4] rangeOfString:DividerForID].location == NSNotFound)) {
        NSString *firstPart = [textField.text substringToIndex:8];
        firstPart = [[firstPart stringByAppendingString:DividerForID] stringByAppendingString:[textField.text substringFromIndex:8]];
        textField.text = firstPart;
    } else if ((textField.text.length == 17 && [[textField.text substringFromIndex:4] rangeOfString:DividerForID].location == NSNotFound)) {
        NSString *firstPart = [textField.text substringToIndex:16];
        firstPart = [[firstPart stringByAppendingString:DividerForID] stringByAppendingString:[textField.text substringFromIndex:16]];
        textField.text = firstPart;
    }
}

@end