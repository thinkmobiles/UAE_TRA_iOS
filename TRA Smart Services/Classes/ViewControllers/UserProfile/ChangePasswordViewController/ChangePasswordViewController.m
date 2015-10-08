//
//  ChangePasswordViewController.m
//  TRA Smart Services
//
//  Created by Admin on 9/11/15.
//

#import "ChangePasswordViewController.h"

#import "UserProfileActionView.h"

#import "UIImage+DrawText.h"
#import "KeychainStorage.h"

@interface ChangePasswordViewController () <UserProfileActionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *retypePasswordLabel;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordTextField;

@property (weak, nonatomic) IBOutlet UserProfileActionView *actionView;

@end

@implementation ChangePasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUserView];
    self.actionView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self fillData];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[self.dynamicService currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [self.actionView localizeUI];
    self.changeLabel.text = dynamicLocalizedString(@"userProfile.changePassword");
    self.oldPasswordLabel.text = dynamicLocalizedString(@"changePassword.oldPassword");
    self.oldPasswordTextField.placeholder = dynamicLocalizedString(@"changePassword.placeHolder.oldPassword");
    self.passwordLabel.text = dynamicLocalizedString(@"changePassword.password");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"changePassword.placeHolder.password");
    self.retypePasswordLabel.text = dynamicLocalizedString(@"changePassword.retypePassword");
    self.retypePasswordTextField.placeholder = dynamicLocalizedString(@"changePassword.placeHolder.retypePassword");
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"fav_back_orange"];
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
}

- (void)setRTLArabicUI
{
    [self updateUI:NSTextAlignmentRight];
    
    [self.actionView setRTLStyle];
}

- (void)setLTREuropeUI
{
    [self updateUI:NSTextAlignmentLeft];
    
    [self.actionView setLTRStyle];
}

#pragma mark - Private Metods

- (void)fillData
{
    UserModel *user = [[KeychainStorage new] loadCustomObjectWithKey:userModelKey];
    if (user.avatarImageBase64.length) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:user.avatarImageBase64 options:kNilOptions];
        UIImage *image = [UIImage imageWithData:data];
        self.userLogoImageView.image = image;
    } else {
        self.userLogoImageView.image = [UIImage imageNamed:@"ic_user_login"];
    }
}

- (void)prepareUserView
{
    self.title = dynamicLocalizedString(@"userProfile.title");
    [AppHelper addHexagoneOnView:self.userLogoImageView];
    [AppHelper addHexagonBorderForLayer:self.userLogoImageView.layer color:[UIColor whiteColor] width:3.0];
    self.userLogoImageView.tintColor = [UIColor whiteColor];
}

- (void)updateUI:(NSTextAlignment)textAlignment
{
    self.oldPasswordLabel.textAlignment = textAlignment;
    self.passwordLabel.textAlignment = textAlignment;
    self.retypePasswordLabel.textAlignment = textAlignment;
    self.oldPasswordTextField.textAlignment = textAlignment;
    self.passwordTextField.textAlignment = textAlignment;
    self.retypePasswordTextField.textAlignment = textAlignment;
    
    [self configureTextField:self.oldPasswordTextField];
    [self configureTextField:self.passwordTextField];
    [self configureTextField:self.retypePasswordTextField];
}

- (void)configureTextField:(UITextField *)textField
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"btn_eye"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_eye"] forState:UIControlStateSelected];
    [button setTintColor:[UIColor grayColor]];
    [button addTarget:self action:@selector(showHidePassword:) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = nil;
    textField.leftView = nil;
    if (self.dynamicService.language == LanguageTypeArabic) {
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = button;
    } else {
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = button;
    }
}

#pragma mark - Actions

- (IBAction)showHidePassword:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [sender setTintColor:sender.isSelected ? self.dynamicService.currentApplicationColor :[UIColor grayColor]];
    [(UITextField *)[sender superview] setSecureTextEntry:!sender.isSelected];
}

#pragma mark - UserProfileActionViewDelegate

- (void)buttonCancelDidTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonResetDidTapped
{
    self.oldPasswordTextField.text = @"";
    self.passwordTextField.text = @"";
    self.retypePasswordTextField.text = @"";
}

- (void)buttonSaveDidTapped
{
    if ([self isInputParametersValid]) {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSChangePassword:self.oldPasswordTextField.text newPassword:self.passwordTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
            } else {
                [[KeychainStorage new] storePassword:self.passwordTextField.text forUser:[KeychainStorage userName]];
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            }
        }];
    }
}

- (BOOL)isInputParametersValid
{
    if (!self.passwordTextField.text.length || !self.retypePasswordTextField.text.length || !self.oldPasswordTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        return NO;
    }
    if (![self.passwordTextField.text isEqualToString:self.retypePasswordTextField.text]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NewPasswordsNotEqual")];
        return NO;
    }
    
    if (self.passwordTextField.text.length < 8) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.PasswordIsTooShort8")];
        return NO;
    } else if (self.passwordTextField.text.length >= 32) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.PasswordIsTooLong32")];
        return NO;
    }
    return YES;
}

@end