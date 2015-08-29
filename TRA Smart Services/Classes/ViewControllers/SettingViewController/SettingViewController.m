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
@property (weak, nonatomic) IBOutlet UIButton *themeColorBlackAndWhite;
@property (weak, nonatomic) IBOutlet UIButton *changeServerButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

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

@property (weak, nonatomic) IBOutlet UIImageView *userUIImageView;
@property (weak, nonatomic) IBOutlet UIImageView *emailUIImageView;
@property (weak, nonatomic) IBOutlet UIImageView *languageUIImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fontSizeUIImageView;
@property (weak, nonatomic) IBOutlet UIImageView *colorOptionUIImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoutUIImageView;

@end

@implementation SettingViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    RTLController *rtl = [[RTLController alloc] init];
    [rtl disableRTLForView:self.view];
    
    [self prepareSegmentsView];
    [self registerForKeyboardNotifications];
    [self prepareUIColors];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height);
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
        case 0: {
            [self makeActiveColorTheme:ApplicationColorBlue];
            [[DynamicUIService service] saveCurrentColorScheme:ApplicationColorBlue];
            break;
        }
        case 1: {
            [self makeActiveColorTheme:ApplicationColorOrange];
            [[DynamicUIService service] saveCurrentColorScheme:ApplicationColorOrange];
            break;
        }
        case 2: {
            [self makeActiveColorTheme:ApplicationColorGreen];
            [[DynamicUIService service] saveCurrentColorScheme:ApplicationColorGreen];
            break;
        }
        case 3: {
            [self makeActiveColorTheme:ApplicationColorBlackAndWhite];
            [[DynamicUIService service] saveCurrentColorScheme:ApplicationColorBlackAndWhite];
            break;
        }
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
    [AppHelper updateFontsOnTabBar];
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
    [AppHelper showLoader];
    [[NetworkManager sharedManager] traSSLogout:^(id response, NSError *error) {
        if (error) {
            [AppHelper alertViewWithMessage:error.localizedDescription];
        } else {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
        }
        [AppHelper hideLoader];
    }];
}

- (IBAction)updateBaseURLButtonTapped:(id)sender
{
    if (!self.baseURLLinkTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    }
    [[NetworkManager sharedManager] setBaseURL:self.baseURLLinkTextField.text];
    [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
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
    UIImage *active = [UIImage imageNamed:@"filledCircle"];
    UIImage *inActive = [UIImage imageNamed:@"check_disact"];
    
    [self.themeBlueButton setImage:inActive forState:UIControlStateNormal];
    [self.themeOrangeButton setImage:inActive forState:UIControlStateNormal];
    [self.themeGreenButton setImage:inActive forState:UIControlStateNormal];
    [self.themeColorBlackAndWhite setImage:inActive forState:UIControlStateNormal];

    [[DynamicUIService service] setColorScheme:selectedColor];

    switch (selectedColor) {
        case ApplicationColorDefault:
        case ApplicationColorBlue: {
            [self.themeBlueButton setImage:active forState:UIControlStateNormal];
            break;
        }
        case ApplicationColorOrange: {
            [self.themeOrangeButton setImage:active forState:UIControlStateNormal];
            break;
        }
        case ApplicationColorGreen: {
            [self.themeGreenButton setImage:active forState:UIControlStateNormal];
            break;
        }
        case ApplicationColorBlackAndWhite: {
            [self.themeColorBlackAndWhite setImage:active forState:UIControlStateNormal];
            break;
        }
    }
    
    [self updateColors];
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
    [self.changeServerButton setTitleColor:[[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
    [self.logoutButton setTintColor:[[DynamicUIService service] currentApplicationColor]];
    
    [self updateTintColorsForImages];
    
    self.languageSegmentControl.segmentSelectedTintColor = [[DynamicUIService service] currentApplicationColor];
    self.textSizeSegmentControll.segmentSelectedTintColor = [[DynamicUIService service] currentApplicationColor];
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

- (void)prepareUIColors
{
    [self.themeBlueButton setTintColor:[UIColor defaultBlueColor]];
    [self.themeGreenButton setTintColor:[UIColor defaultGreenColor]];
    [self.themeOrangeButton setTintColor:[UIColor defaultOrangeColor]];
    [self.themeColorBlackAndWhite setTintColor:[UIColor blackColor]];
}

- (void)updateTintColorsForImages
{
    UIColor *color = [[DynamicUIService service] currentApplicationColor];
    
    self.logoutUIImageView.tintColor = color;
    self.userUIImageView.tintColor = color;
    self.emailUIImageView.tintColor = color;
    self.languageUIImageView.tintColor = color;
    self.fontSizeUIImageView.tintColor = color;
    self.colorOptionUIImageView.tintColor = color;
}

@end
