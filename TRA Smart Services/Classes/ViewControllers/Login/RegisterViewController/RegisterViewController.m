//
//  RegisterViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "RegisterViewController.h"
#import "TextFieldNavigator.h"

static CGFloat const PickerExpandedHeightValue = 150.f;

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
@property (weak, nonatomic) IBOutlet UIButton *selectStateButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLogoImageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) CGFloat offSetTextFildY;

@property (strong, nonatomic) NSArray *pickerDataSource;
@property (assign, nonatomic) NSInteger selectedState;

@end

@implementation RegisterViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareNotification];
    [self prepareLogoImageView];
    [self updateColors];
    [self prepareDataSource];
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
                CGFloat offset = textField.tag == 5 ? 200.f : 50.f;
                [weakSelf.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + offset)];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pickerDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pickerCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickerCell"];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedState = indexPath.row;
    [self.selectStateButton setTitle:self.pickerDataSource[indexPath.row] forState:UIControlStateNormal];
    [self hidePickerTable];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:14.f] : [UIFont latoRegularWithSize:14.f];
    cell.textLabel.text = self.pickerDataSource[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - IBActions

- (IBAction)selectStateButtonTapped:(id)sender
{
    if (self.tableView.hidden) {
        [self.view layoutIfNeeded];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.tableView.hidden = NO;
            weakSelf.tableViewHeightConstraint.constant = PickerExpandedHeightValue;
            [weakSelf.view layoutIfNeeded];
        }];
    } else {
        [self hidePickerTable];
    }
}

- (IBAction)registerButtonPress:(id)sender
{
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.PasswordsNotEqual")];
        return;
    }
    if (self.userNameTextField.text.length && self.genderTextField.text.length && self.mobileTextField.text.length && self.passwordTextField.text.length && self.confirmPasswordTextField.text.length && self.firstNameTextField.text.length && self.emiratesIDTextField.text.length && self.lastNameTextField.text.length && self.addressTextField.text.length && self.landlineTextField.text.length && self.countryTextField.text.length && self.emailTextField.text.length) {
        
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

- (void)hidePickerTable
{
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.tableViewHeightConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.tableView.hidden = YES;
    }];
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
    [self prepareDataSource];
//    [self.statePicker reloadAllComponents];
    
    self.title = dynamicLocalizedString(@"register.title");
    self.userNameTextField.placeholder = dynamicLocalizedString(@"register.placeholderText.username");
    self.genderTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.gender");
    self.mobileTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.phone");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.password");
    self.confirmPasswordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.confirmPassword");
    self.firstNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.firstName");
    self.lastNameTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.lastName");
    self.addressTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.address");
    self.landlineTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.landline");
    self.countryTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.country");
    self.emailTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.email");
    self.emiratesIDTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.emirateID");
    [self.registerButton setTitle:dynamicLocalizedString(@"register.button.register") forState:UIControlStateNormal];
    [self.loginButton setTitle:dynamicLocalizedString(@"register.button.login") forState:UIControlStateNormal];
    [self.selectStateButton setTitle:dynamicLocalizedString(@"state.SelectState") forState:UIControlStateNormal];
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

- (void)prepareDataSource
{
    self.pickerDataSource = @[
                              dynamicLocalizedString(@"state.Abu.Dhabi"),
                              dynamicLocalizedString(@"state.Ajman"),
                              dynamicLocalizedString(@"state.Dubai"),
                              dynamicLocalizedString(@"state.Fujairah"),
                              dynamicLocalizedString(@"state.Ras"),
                              dynamicLocalizedString(@"state.Sharjan"),
                              dynamicLocalizedString(@"state.Quwain")
                              ];
    self.selectedState = -1;
}

@end