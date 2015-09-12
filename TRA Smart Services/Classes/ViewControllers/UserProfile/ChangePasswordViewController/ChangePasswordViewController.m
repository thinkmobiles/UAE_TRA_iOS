//
//  ChangePasswordViewController.m
//  TRA Smart Services
//
//  Created by Anatoliy Dalekorey on 9/11/15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserProfileActionView.h"
#import "UIImage+DrawText.h"

@interface ChangePasswordViewController () <UserProfileActionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *retypePasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordTextField;
@property (weak, nonatomic) IBOutlet UserProfileActionView *actionView;

@end

@implementation ChangePasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUserView];
    self.actionView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[DynamicUIService service] currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
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
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
    
    [super addHexagonBorderForLayer:self.userLogoImageView.layer color:[UIColor whiteColor]];
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
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

- (void)prepareUserView
{
    self.title = dynamicLocalizedString(@"userProfile.title");
    self.userLogoImageView.image = [UIImage imageNamed:@"test"];
    [super addHexagoneOnView:self.userLogoImageView];
}

- (void)clearPassword
{
    self.passwordTextField.text = @"";
    self.retypePasswordTextField.text = @"";
}

- (void)updateUI:(NSTextAlignment)textAlignment
{
    self.oldPasswordLabel.textAlignment = textAlignment;
    self.oldPasswordTextField.textAlignment = textAlignment;
    self.passwordLabel.textAlignment = textAlignment;
    self.passwordTextField.textAlignment = textAlignment;
    self.retypePasswordLabel.textAlignment = textAlignment;
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
    if ([DynamicUIService service].language == LanguageTypeArabic) {
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
    [sender setTintColor:sender.isSelected ? [DynamicUIService service].currentApplicationColor :[UIColor grayColor]];
    [(UITextField *)[sender superview] setSecureTextEntry:!sender.isSelected];
}

#pragma mark - UserProfileActionViewDelegate

- (void)buttonCancelDidTapped
{
    self.oldPasswordTextField.text = @"";
    [self clearPassword];
}

- (void)buttonResetDidTapped
{
    [self clearPassword];
}

- (void)buttonSaveDidTapped
{
    [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.notImplemented")];
}

@end
