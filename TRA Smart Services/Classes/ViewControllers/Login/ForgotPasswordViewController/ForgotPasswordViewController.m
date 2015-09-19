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

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet OffsetTextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end

@implementation ForgotPasswordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
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
    [self.mainButton setTitleColor:[self.dynamicService currentApplicationColor] forState:UIControlStateNormal];
    self.informationLabel.textColor = [self.dynamicService currentApplicationColor];
    UIImage *backgroundImage = [UIImage imageNamed:@"res_img_bg"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
}

@end
