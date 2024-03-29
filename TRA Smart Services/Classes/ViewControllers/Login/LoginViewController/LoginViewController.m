//
//  LoginViewController.m
//  TRA Smart Services
//
//  Created by Admin on 20.07.15.
//

#import "LoginViewController.h"
#import "Animation.h"
#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
#import "TextFieldNavigator.h"
#import "KeychainStorage.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet LeftInsetTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIView *userNameSeparator;
@property (weak, nonatomic) IBOutlet UIView *passwordSeparator;
@property (weak, nonatomic) IBOutlet UIView *loginSeparator;
@property (weak, nonatomic) IBOutlet UIView *verticalSeparator;

@property (strong, nonatomic) KeychainStorage *storage;
@property (assign, nonatomic) BOOL isViewControllerPresented;

@end

@implementation LoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.storage = [[KeychainStorage alloc] init];
    [self prepareNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if (!self.isViewControllerPresented) {
        [self.view.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
        self.view.layer.opacity = 1.0f;
        self.isViewControllerPresented = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.navigationController.viewControllers.count == 1) {
        if (self.didDismissed) {
            self.didDismissed();
        }
    }
}

#pragma mark - Superclass Methods

- (void)returnKeyDone
{
    [self loginButtonPressed:nil];
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender
{
    if (self.userNameTextField.text.length && self.passwordTextField.text.length) {
        if (![self.userNameTextField.text isValidUserName]) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatUserName")];
            return;
        }
        
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        
        __weak typeof(self) weakSelf = self;
        void(^UpdateAvatar)(UserModel *user) = ^(UserModel *user) {
            [[NetworkManager sharedManager] traSSGetImageWithPath:user.uriForImage withCompletition:^(BOOL success, UIImage *response) {
                if (success) {
                    NSData *imageData = UIImageJPEGRepresentation(response, 1.0);
                    NSString *encodedString = [imageData base64EncodedStringWithOptions:kNilOptions];
                    UserModel *user = [[KeychainStorage new] loadCustomObjectWithKey:userModelKey];
                    user.avatarImageBase64 = encodedString;
                    [[KeychainStorage new] saveCustomObject:user key:userModelKey];
                }
                if (weakSelf.shouldAutoCloseAfterLogin) {
                    weakSelf.didCloseViewController = nil;
                    [weakSelf closeButtonPressed];
                }
                [loader dismissTRALoader];
            }];
        };
        
        void(^GetUserProfile)() = ^() {
            [[NetworkManager sharedManager] traSSGetUserProfileResult:^(id response, NSError *error) {
                UserModel *user = [[UserModel alloc] initWithDictionary:response];
                [[KeychainStorage new] saveCustomObject:user key:userModelKey];
                UpdateAvatar(user);
            }];
        };
        
        [[NetworkManager sharedManager] traSSLoginUsername:self.userNameTextField.text password:self.passwordTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [response isKindOfClass:[NSString class]] ? [AppHelper alertViewWithMessage:response] : [AppHelper alertViewWithMessage:error.localizedDescription];
                [loader dismissTRALoader];
            } else {
                [weakSelf.storage storePassword:weakSelf.passwordTextField.text forUser:weakSelf.userNameTextField.text];
                GetUserProfile();
            }
        }];
        
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    }
}

- (void)closeButtonPressed
{
    self.navigationController.navigationBar.hidden = YES;
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:1.f to:0.0f delegate:self] forKey:@"dismissView"];
    self.view.layer.opacity = 0.0f;
    if (self.didCloseViewController) {
        self.didCloseViewController();
    }
}

#pragma mark - Animations

- (void)animationDidStop:(nonnull CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.view.layer animationForKey:@"dismissView"]) {
        [self.view.layer removeAllAnimations];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Private

- (void)updateUI:(NSTextAlignment)textAlignment
{
    [self configureTextField:self.userNameTextField withImageName:@"ic_user_login"];
    [self configureTextField:self.passwordTextField withImageName:@"ic_pass"];
    
    self.userNameTextField.textAlignment = textAlignment;
    self.passwordTextField.textAlignment = textAlignment;
}

#pragma mark - UI

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"login.title");
    self.userNameTextField.placeholder = dynamicLocalizedString(@"login.placeHolderText.username");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"login.placeHolderText.password");
    [self.loginButton setTitle:dynamicLocalizedString(@"login.button.login") forState:UIControlStateNormal];;
    [self.forgotPasswordButton setTitle:dynamicLocalizedString(@"login.button.forgotPassword") forState:UIControlStateNormal];
    [self.registerButton setTitle:dynamicLocalizedString(@"login.button.registerButton") forState:UIControlStateNormal];;
}

- (void)updateColors
{
    UIColor *color = [self.dynamicService currentApplicationColor];
    [self.loginButton setBackgroundColor:color];
    [self.registerButton setTitleColor:color forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitleColor:color forState:UIControlStateNormal];
    
    [self.userNameTextField.leftView setTintColor:color];
    [self.userNameTextField.rightView setTintColor:color];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:dynamicLocalizedString(@"login.placeHolderText.username") attributes:@{NSForegroundColorAttributeName: color}];
    self.userNameTextField.textColor = color;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:dynamicLocalizedString(@"login.placeHolderText.password") attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.textColor = color;
    
    self.userNameSeparator.backgroundColor = color;
    self.passwordSeparator.backgroundColor = color;
    self.loginSeparator.backgroundColor = color;
    self.verticalSeparator.backgroundColor = color;
    
    [super updateBackgroundImageNamed:@"res_img_bg"];
}

- (void)setLTREuropeUI
{
    [self updateUI:NSTextAlignmentLeft];
}

- (void)setRTLArabicUI
{
    [self updateUI:NSTextAlignmentRight];
}

- (void)prepareNavigationBarButton
{
    [self.navigationController setButtonWithImageNamed:CloseButtonImageName andActionDelegate:self tintColor:[UIColor whiteColor] position:ButtonPositionModeLeft selector:@selector(closeButtonPressed)];
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    [self prepareNavigationBarButton];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
}

@end