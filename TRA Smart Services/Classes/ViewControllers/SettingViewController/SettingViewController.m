//
//  SettingViewController.m
//  TRA Smart Services
//
//  Created by Admin on 22.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SettingViewController.h"

typedef NS_ENUM(NSUInteger, ColorTheme) {
    ColorThemeBlue,
    ColorThemeOrange,
    ColorThemeGreen,
};

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *themeBlueButton;
@property (weak, nonatomic) IBOutlet UIButton *themeOrangeButton;
@property (weak, nonatomic) IBOutlet UIButton *themeGreenButton;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        UIResponder *nextResponder = self.emailTextField;
        [nextResponder becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyDone) {
        [self.view endEditing:YES];
        return YES;
    }
    return NO;
}

#pragma mark - Private

- (void) makeActiveColorTheme: (ColorTheme) selectedColor
{
    self.themeBlueButton.backgroundColor = [UIColor whiteColor];
    self.themeOrangeButton.backgroundColor = [UIColor whiteColor];
    self.themeGreenButton.backgroundColor = [UIColor whiteColor];

    switch (selectedColor) {
        case ColorThemeBlue:
            self.themeBlueButton.backgroundColor = [UIColor blueColor];
            break;
        case ColorThemeOrange:
            self.themeOrangeButton.backgroundColor = [UIColor orangeColor];
            break;
        case ColorThemeGreen:
            self.themeGreenButton.backgroundColor = [UIColor greenColor];
            break;
    }
}
 - (IBAction)selectedThemes:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [self makeActiveColorTheme:ColorThemeBlue];
            break;
        case 1:
            [self makeActiveColorTheme:ColorThemeOrange];
            break;
        case 2:
            [self makeActiveColorTheme:ColorThemeGreen];
            break;
    }
}

@end
