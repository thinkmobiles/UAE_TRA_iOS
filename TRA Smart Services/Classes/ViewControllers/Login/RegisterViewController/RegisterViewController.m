//
//  RegisterViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet OffsetTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *genderTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet OffsetTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topYSpaceForRegisterButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomYSpaceForRegisterButtonConstraint;

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
    
    [self updateUIIfNeeded];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareNavigationBar];
}

#pragma mark - IBActions

- (IBAction)registerButtonPress:(id)sender
{
    if (self.userNameTextField.text.length && self.genderTextField.text.length && self.phoneTextField.text.length && self.passwordTextField.text.length) {
        [AppHelper showLoader];
        __weak typeof(self) weakSelf = self;

        [[NetworkManager sharedManager] traSSRegisterUsername:self.userNameTextField.text password:self.passwordTextField.text gender:self.genderTextField.text phoneNumber:self.phoneTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:response];
            }
            
            weakSelf.userNameTextField.text = @"";
            weakSelf.genderTextField.text = @"";
            weakSelf.phoneTextField.text = @"";
            weakSelf.passwordTextField.text = @"";
            
            [AppHelper hideLoader];
        }];
    } else {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    }
}

- (IBAction)loginButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"register.title");
    self.userNameTextField.placeholder = dynamicLocalizedString(@"register.placeholderText.username");
    self.genderTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.gender");
    self.phoneTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.phone");
    self.passwordTextField.placeholder = dynamicLocalizedString(@"register.placeHolderText.password");
    [self.registerButton setTitle:dynamicLocalizedString(@"register.button.register") forState:UIControlStateNormal];
    [self.loginButton setTitle:dynamicLocalizedString(@"register.button.login") forState:UIControlStateNormal];
}

- (void)updateColors
{
    
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    self.title = dynamicLocalizedString(@"register.title");
}

- (void)updateUIIfNeeded
{
    if (IS_IPHONE_5) {
        self.topYSpaceForRegisterButtonConstraint.constant = 0.f;
        self.bottomYSpaceForRegisterButtonConstraint.constant = 8.f;
    } else if (IS_IPHONE_4_OR_LESS) {
        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 600);
    }
}

@end