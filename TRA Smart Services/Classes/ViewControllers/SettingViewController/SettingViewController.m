//
//  SettingViewController.m
//  TRA Smart Services
//
//  Created by Admin on 22.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SettingViewController.h"
#import "RTLController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *themeBlueButton;
@property (weak, nonatomic) IBOutlet UIButton *themeOrangeButton;
@property (weak, nonatomic) IBOutlet UIButton *themeGreenButton;

@property (weak, nonatomic) IBOutlet SegmentView *languageSegmentControl;
@property (weak, nonatomic) IBOutlet SegmentView *textSizeSegmentControll;

@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutGuideConstraint;

@property (weak, nonatomic) IBOutlet UITextField *baseURLLinkTextField;

@end

@implementation SettingViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self prepareSegmentsView];
    
    RTLController *rtl = [[RTLController alloc] init];
    [rtl disableRTLForView:self.view];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateLanguageSegmentControlPosition];
    [self updateFontSizeSegmentControlPosition];
    
    [self makeActiveColorTheme:[DynamicUIService service].colorScheme];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    [AppHelper updateTabBarTintColor];
    [AppHelper updateNavigationBarColor];
}

- (void)languageSegmentControllerPressed:(NSUInteger)index
{
    switch (index) {
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
    [AppHelper localizeTitlesOnTabBar];
    [self updateLanguageSegmentControlPosition];
}

- (void)textSizeSegmentControlPressed:(NSUInteger)index
{
    switch (index) {
        case 0: {
            if ([DynamicUIService service].fontSize == ApplicationFontBig) {
                return;
            }
            [[DynamicUIService service] saveCurrentFontSize:ApplicationFontBig];
            break;
        }
        case 1: {
            if ([DynamicUIService service].fontSize == ApplicationFontSmall) {
                return;
            }
            [[DynamicUIService service] saveCurrentFontSize:ApplicationFontSmall];
            break;
        }
    }
    
    [AppHelper updateFontsOnTabBar];
    [self updateFontSizeSegmentControlPosition];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    
}

- (IBAction)updateBaseURLButtonTapped:(id)sender
{
    if (!self.baseURLLinkTextField.text.length) {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    }
    [[NetworkManager sharedManager] setBaseURL:self.baseURLLinkTextField.text];
    [AppHelper alertViewWithMessage:MessageSuccess];
}

#pragma mark - SegmentViewDelegate

 - (void)segmentControlDidPressedItem:(NSUInteger)item inSegment:(SegmentView *)segment
{
    switch (segment.segmentTag) {
        case 1: {
            [self languageSegmentControllerPressed:item];
            break;
        }
        case 2: {
            [self textSizeSegmentControlPressed:item];
            break;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        UIResponder *nextResponder = self.emailTextField;
        [nextResponder becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyDone) {
        [self.view endEditing:YES];
        if (textField.tag == 10) {
            [self.view layoutIfNeeded];
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.scrollView setContentOffset:CGPointZero];
                [weakSelf.view layoutIfNeeded];
            }];
        }
        return YES;
    }
    return NO;
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboadWillShow:(NSNotification*)notification
{
    if ([self.baseURLLinkTextField isFirstResponder]) {
        [self.view layoutIfNeeded];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 200)];
            [weakSelf.view layoutIfNeeded];
        }];
    }
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
    self.languageSegmentControl.segmentItems = @[dynamicLocalizedString(@"settings.switchControl.language.arabic"), dynamicLocalizedString(@"setting.switchControl.language.english")];
    self.textSizeSegmentControll.segmentItems = @[dynamicLocalizedString(@"setting.switchControl.textSize.big"), dynamicLocalizedString(@"setting.switchControl.textSize.small")];
}

- (void)updateColors
{
    
}

- (void)updateLanguageSegmentControlPosition
{
    switch ([DynamicUIService service].language) {
        case LanguageTypeDefault:
        case LanguageTypeArabic : {
            [self.languageSegmentControl setSegmentItemSelectedWithTag:1];
            break;
        }
        case LanguageTypeEnglish: {
            [self.languageSegmentControl setSegmentItemSelectedWithTag:0];
            break;
        }
    }
}

- (void)updateFontSizeSegmentControlPosition
{
    switch ([DynamicUIService service].fontSize) {
        case ApplicationFontUndefined:
        case ApplicationFontSmall: {
            [self.textSizeSegmentControll setSegmentItemSelectedWithTag:0];
            break;
        }
        case ApplicationFontBig: {
            [self.textSizeSegmentControll setSegmentItemSelectedWithTag:1];

            break;
        }
    }
}

- (void)prepareSegmentsView
{
    self.languageSegmentControl.delegate = self;
    self.textSizeSegmentControll.delegate = self;
    
    NSDictionary *smallTextAttributes = @{
                                         NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14.f]
                                         };
    NSDictionary *bigTextattributes = @{
                                        NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Light" size:22.f]
                                        };
    self.textSizeSegmentControll.segmentItemsAttributes = @[bigTextattributes, smallTextAttributes];
    self.languageSegmentControl.segmentItemsAttributes = @[smallTextAttributes, smallTextAttributes];
}

@end
