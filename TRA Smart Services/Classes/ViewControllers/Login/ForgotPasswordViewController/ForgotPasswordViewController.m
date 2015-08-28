//
//  ForgotPasswordViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Animation.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet OffsetTextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end

@implementation ForgotPasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareNavigationBar];
}

#pragma mark - IBActions

- (IBAction)restorePasswordPressed:(id)sender
{
    
}

- (void)closeButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    self.title = dynamicLocalizedString(@"restorePassword.title");
}

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"restorePassword.title");
    self.userEmailTextField.placeholder = dynamicLocalizedString(@"restorePassword.PlaceholderText.email");
    [self.mainButton setTitle:dynamicLocalizedString(@"restorePassword.button.restore") forState:UIControlStateNormal];
    self.informationLabel.text = dynamicLocalizedString(@"restorePassword.information.label.text");
}

- (void)updateColors
{
    self.logoImageView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
    [self.mainButton setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    self.informationLabel.textColor = [[DynamicUIService service] currentApplicationColor];
}

@end
