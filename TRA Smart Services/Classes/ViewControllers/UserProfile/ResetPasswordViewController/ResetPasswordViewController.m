//
//  ResetPasswordViewController.m
//  TRA Smart Services
//
//  Created by Admin on 9/11/15.
//

#import "ResetPasswordViewController.h"
#import "UIImage+DrawText.h"

@interface ResetPasswordViewController () 

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[self.dynamicService currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
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
    UIColor *color = [self.dynamicService currentApplicationColor];
    [super updateBackgroundImageNamed:@"fav_back_orange"];
    [AppHelper addHexagonBorderForLayer:self.userLogoImageView.layer color:color width:3.];
    self.userLogoImageView.tintColor = color;
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
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
    self.userLogoImageView.image = [UIImage imageNamed:@"ic_user_login"];
    [AppHelper addHexagoneOnView:self.userLogoImageView];
    self.userLogoImageView.backgroundColor = [UIColor whiteColor];
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
