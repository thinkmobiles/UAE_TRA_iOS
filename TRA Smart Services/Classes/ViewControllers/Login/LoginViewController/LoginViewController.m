//
//  LoginViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "LoginViewController.h"
#import "Animation.h"
#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"

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
        
    if (!self.isViewControllerPresented) {
        [self.view.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
        self.view.layer.opacity = 1.0f;
        self.isViewControllerPresented = YES;
    }
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender
{
    if (self.userNameTextField.text.length && self.passwordTextField.text.length) {
        [AppHelper showLoader];
        __weak typeof(self) weakSelf = self;
        
        [[NetworkManager sharedManager] traSSLoginUsername:self.userNameTextField.text password:self.passwordTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:response];
            }
            
            weakSelf.userNameTextField.text = @"";
            weakSelf.passwordTextField.text = @"";
            
            [AppHelper hideLoader];
        }];
    } else {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    }
}

- (IBAction)registerButtonPressed:(id)sender
{
    
}

- (void)closeButtonPressed
{
    self.navigationController.navigationBar.hidden = YES;
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

- (void)updateColors
{
    
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