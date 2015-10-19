//
//  ForgotPasswordViewController.m
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#import "ForgotPasswordViewController.h"
#import "Animation.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet OffsetTextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end

@implementation ForgotPasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareNavigationBar];
}

#pragma mark - IBActions

- (IBAction)restorePasswordPressed:(id)sender
{
    if (!self.userEmailTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else if (![self.userEmailTextField.text isValidEmailUseHardFilter:NO]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatEmail")];
    } else {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSForgotPasswordForEmail:self.userEmailTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:[response isKindOfClass:[NSString class]] ? response : dynamicLocalizedString(@"api.message.serverError")];
            } else {
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            }
        }];
    }
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
    [self.mainButton setTitleColor:[self.dynamicService currentApplicationColor] forState:UIControlStateNormal];
    self.informationLabel.textColor = [self.dynamicService currentApplicationColor];
    [super updateBackgroundImageNamed:@"res_img_bg"];
}

@end