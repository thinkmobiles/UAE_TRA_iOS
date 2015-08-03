//
//  SettingViewController.m
//  TRA Smart Services
//
//  Created by Admin on 22.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImage+DrawText.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *themeBlueButton;
@property (weak, nonatomic) IBOutlet UIButton *themeOrangeButton;
@property (weak, nonatomic) IBOutlet UIButton *themeGreenButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *languageSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textSizeSegmentControll;

@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation SettingViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self updateLanguageSegmentControlPosition];
//    [self updateFontSizeSegmentControlPosition];
    
    [self customizeSegmentControl:self.textSizeSegmentControll];
    [self customizeSegmentControl:self.languageSegmentControl];
    
    [self makeActiveColorTheme:[DynamicUIService service].colorScheme];
}

#pragma mark - IBActions

- (IBAction)selectedThemes:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [self makeActiveColorTheme:ApplicationColorBlue];
            [[DynamicUIService service] saveCurrentColorScheme:ApplicationColorBlue];
            break;
        case 1:
            [self makeActiveColorTheme:ApplicationColorOrange];
            [[DynamicUIService service] saveCurrentColorScheme:ApplicationColorOrange];
            break;
        case 2:
            [self makeActiveColorTheme:ApplicationColorGreen];
            [[DynamicUIService service] saveCurrentColorScheme:ApplicationColorGreen];
            break;
    }
}

- (IBAction)languageSegmentControllerPressed:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0: {
            [[DynamicUIService service] setLanguage:LanguageTypeArabic];
            break;
        }
        case 1: {
            [[DynamicUIService service] setLanguage:LanguageTypeEnglish];
            break;
        }
    }
    [self localizeUI];
}

- (IBAction)textSizeSegmentControlPressed:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0: {
            [[DynamicUIService service] saveCurrentFontSize:ApplicationFontBig];
            break;
        }
        case 1: {
            [[DynamicUIService service] saveCurrentFontSize:ApplicationFontSmall];

            break;
        }
    }
    [self updateSubviewForParentViewIfPossible:self.view];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    
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

- (void)makeActiveColorTheme:(ApplicationColor)selectedColor
{
    self.themeBlueButton.backgroundColor = [UIColor whiteColor];
    self.themeOrangeButton.backgroundColor = [UIColor whiteColor];
    self.themeGreenButton.backgroundColor = [UIColor whiteColor];

    [[DynamicUIService service] setColorScheme:selectedColor];

    switch (selectedColor) {
        case ApplicationColorDefault:
        case ApplicationColorBlue: {
            self.themeBlueButton.backgroundColor = [[DynamicUIService service] currentApplicationColor];
            break;
        }
        case ApplicationColorOrange: {
            self.themeOrangeButton.backgroundColor = [[DynamicUIService service] currentApplicationColor];
            break;
        }
        case ApplicationColorGreen: {
            self.themeGreenButton.backgroundColor = [[DynamicUIService service] currentApplicationColor];
            break;
        }
    }
}

#pragma mark - UIUpdate

- (void)localizeUI
{
    self.userNameTextField.placeholder = dynamicLocalizedString(@"settings.textfield.username");
    self.emailTextField.placeholder = dynamicLocalizedString(@"settings.textfield.email");
    self.languageLabel.text = dynamicLocalizedString(@"settings.label.language");
    self.fontSizeLabel.text = dynamicLocalizedString(@"settings.label.fontsize");
    self.colorThemeLabel.text = dynamicLocalizedString(@"settings.label.themeOption");
    self.logoutLabel.text = dynamicLocalizedString(@"settings.label.logout");
    self.emailLabel.text = dynamicLocalizedString(@"settings.textfield.email");
    self.userNameLabel.text = dynamicLocalizedString(@"settings.textfield.username");
    [self.languageSegmentControl setTitle:dynamicLocalizedString(@"settings.switchControl.language.arabic") forSegmentAtIndex:0];
    [self.languageSegmentControl setTitle:dynamicLocalizedString(@"setting.switchControl.language.english") forSegmentAtIndex:1];
}

- (void)customizeSegmentControl:(UISegmentedControl *)segmentControl
{
    segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentControl.layer.borderWidth = 3.f;

    [segmentControl setDividerImage:[UIImage imageWithColor:[UIColor lightGrayColor] inRect:CGRectMake(0, 0, 1, 1)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)updateColors
{
    
}

- (void)updateLanguageSegmentControlPosition
{
    switch ([DynamicUIService service].language) {
        case LanguageTypeDefault:
        case LanguageTypeArabic : {
            self.languageSegmentControl.selectedSegmentIndex = 0;
            break;
        }
        case LanguageTypeEnglish: {
            self.languageSegmentControl.selectedSegmentIndex = 1;
            break;
        }
            
        default:
            break;
    }
}

- (void)updateFontSizeSegmentControlPosition
{
    switch ([DynamicUIService service].fontSize) {
        case ApplicationFontUndefined:
        case ApplicationFontSmall: {
            self.textSizeSegmentControll.selectedSegmentIndex = 1;
            break;
        }
        case ApplicationFontBig: {
            self.textSizeSegmentControll.selectedSegmentIndex = 0;
            break;
        }
    }
}

@end
