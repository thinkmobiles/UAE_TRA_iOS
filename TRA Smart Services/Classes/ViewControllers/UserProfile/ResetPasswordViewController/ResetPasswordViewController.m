//
//  ResetPasswordViewController.m
//  TRA Smart Services
//
//  Created by Anatoliy Dalekorey on 9/11/15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UserProfileActionView.h"
#import "UIImage+DrawText.h"

@interface ResetPasswordViewController () <UserProfileActionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *resetLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *retypeEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *retypeEmailTextField;
@property (weak, nonatomic) IBOutlet UserProfileActionView *actionView;

@end

@implementation ResetPasswordViewController

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
    self.resetLabel.text = dynamicLocalizedString(@"userProfile.resetPassword");
    self.infoLabel.text = dynamicLocalizedString(@"resetPassword.info");
    self.emailLabel.text = dynamicLocalizedString(@"resetPassword.email");
    self.emailTextField.placeholder = dynamicLocalizedString(@"resetPassword.placeHolder.email");
    self.retypeEmailLabel.text = dynamicLocalizedString(@"resetPassword.retypeEmail");
    self.retypeEmailTextField.placeholder = dynamicLocalizedString(@"resetPassword.placeHolder.retypeEmail");
}

- (void)updateColors
{
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
    
    [AppHelper addHexagonBorderForLayer:self.userLogoImageView.layer color:[UIColor whiteColor] width:3.];
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
    [AppHelper addHexagoneOnView:self.userLogoImageView];
}

- (void)updateUI:(NSTextAlignment)textAlignment
{
    self.emailLabel.textAlignment = textAlignment;
    self.emailTextField.textAlignment = textAlignment;
    self.retypeEmailLabel.textAlignment = textAlignment;
    self.retypeEmailTextField.textAlignment = textAlignment;
}

#pragma mark - UserProfileActionViewDelegate

- (void)buttonCancelDidTapped
{
    self.emailTextField.text = @"";
    self.retypeEmailTextField.text = @"";
}

- (void)buttonResetDidTapped
{
    self.emailTextField.text = @"";
    self.retypeEmailTextField.text = @"";
}

- (void)buttonSaveDidTapped
{
    [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.notImplemented")];
}

@end
