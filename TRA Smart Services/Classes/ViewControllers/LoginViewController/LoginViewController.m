//
//  LoginViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "LoginViewController.h"
#import "Animation.h"

static NSString *const CloseButtonImageName = @"close";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet OffsetTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (assign, nonatomic) BOOL isViewControllerPresented;

@end

@implementation LoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self localizeUI];
    
    if (!self.isViewControllerPresented) {
        [self.view.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
        self.view.layer.opacity = 1.0f;
        self.isViewControllerPresented = YES;
    }
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender
{
    
}

- (IBAction)forgotPasswordButtonPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[AppHelper appName] message:dynamicLocalizedString(@"login.restore_password.message") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (IBAction)registerButtonPressed:(id)sender
{
    
}

- (void)closeButtonPressed
{
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:1.f to:0.0f delegate:self] forKey:@"dismissView"];
    self.view.layer.opacity = 0.0f;
}

#pragma mark - Animations

- (void)animationDidStop:(nonnull CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.view.layer animationForKey:@"dismissView"]) {
        [self.view.layer removeAllAnimations];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *emailTextFieldText = (UITextField *)[alertView textFieldAtIndex:0].text;
    NSLog(@"%@",emailTextFieldText);
}

#pragma mark - Private

#pragma mark - UI

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"login.title");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"login.placeHolderText.username");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"login.placeHolderText.password");
    self.loginButton.titleLabel.text = dynamicLocalizedString(@"login.button.login");
    self.forgotPasswordButton.titleLabel.text = dynamicLocalizedString(@"login.button.forgotPassword");
    self.registerButton.titleLabel.text = dynamicLocalizedString(@"login.button.registerButton");
}

- (void)prepareNavigationBarButton
{
    [self.navigationController setButtonWithImageNamed:CloseButtonImageName andActionDelegate:self tintColor:[UIColor whiteColor] position:ButtonPositionModeLeft selector:@selector(closeButtonPressed)];
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    [self prepareNavigationBarButton];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStyleBordered target:nil action:nil];
}

@end