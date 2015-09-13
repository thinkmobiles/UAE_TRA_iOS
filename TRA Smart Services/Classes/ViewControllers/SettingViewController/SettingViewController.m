//
//  SettingViewController.m
//  TRA Smart Services
//
//  Created by Admin on 22.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "SettingViewController.h"
#import "RTLController.h"
#import "UIImage+DrawText.h"

static NSInteger const themeColorBlackAndWhite = 3;
static CGFloat const optionScaleSwitch = 0.55;

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *conteinerView;
@property (weak, nonatomic) IBOutlet UIView *conteinerButtonColorThemeView;
@property (weak, nonatomic) IBOutlet UIView *containerSliderView;

@property (weak, nonatomic) IBOutlet UISwitch *screenLockNotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *appTutorialScreensSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *themeColorBlackAndWhiteSwitch;
@property (weak, nonatomic) IBOutlet UIButton *themeBlueButton;
@property (weak, nonatomic) IBOutlet UIButton *themeOrangeButton;
@property (weak, nonatomic) IBOutlet UIButton *themeGreenButton;

@property (weak, nonatomic) IBOutlet SegmentView *languageSegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorImpairedLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenLockNotificationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenLockNotificationDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *appTutorialScreensTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *appTutorialScreensDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorThemeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorThemeDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutTRATitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutTRADetailsLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftFontSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerFontSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightFontSizeLabel;

@end

@implementation SettingViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RTLController *rtl = [[RTLController alloc] init];
    [rtl disableRTLForView:self.view];
    
    [self prepareSegmentsView];
    [self prepareUISwitchSettingViewController];
    [self prepareNavigationBar];
    [self prepareFontSizeSlider];
    [self updateFontSizeSliderColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateColorForDescriptioveTextSize];
    [self updateLanguageSegmentControlPosition];
    [self updateFontSizeControl];
    [self makeActiveColorTheme:[DynamicUIService service].colorScheme];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - IBActions

- (void)selectThemeColorBlackAndWhiteSwitch:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        [self selectColorTheme:themeColorBlackAndWhite];
    } else {
        [self selectColorTheme:[self currentColorThemaUserDefaults]];
    }
}

- (IBAction)selectedThemes:(id)sender
{
    [self selectColorTheme:[sender tag]];
    
    [self.themeColorBlackAndWhiteSwitch setOn:NO animated:YES];
    [self setCurrentColorThemaUserDefaults:[sender tag]];
}

- (void)languageSegmentControllerPressed:(NSUInteger)index
{
    switch (index) {
        case 0: {
            if ([DynamicUIService service].language == LanguageTypeEnglish) {
                [self transformAnimationConteinerView];
            }
            [[DynamicUIService service] setLanguage:LanguageTypeArabic];
            break;
        }
        case 1: {
            if ([DynamicUIService service].language == LanguageTypeArabic) {
                [self transformAnimationConteinerView];
            }
            [[DynamicUIService service] setLanguage:LanguageTypeEnglish];
            break;
        }
    }
    [self localizeUI];
    [AppHelper localizeTitlesOnTabBar];
    [AppHelper updateFontsOnTabBar];
    [self updateLanguageSegmentControlPosition];
}

- (IBAction)sliderDidChangeValue:(UISlider *)sender
{
    sender.value = roundf(sender.value / sender.maximumValue * 2) * sender.maximumValue / 2;

    switch ((int)sender.value) {
        case 0: {
            if ([DynamicUIService service].fontSize == ApplicationFontSmall) {
                return;
            }
            [[DynamicUIService service] saveCurrentFontSize:ApplicationFontSmall];
            break;
        }
        case 1: {
            if ([DynamicUIService service].fontSize == ApplicationFontUndefined) {
                return;
            }
            [[DynamicUIService service] saveCurrentFontSize:ApplicationFontUndefined];
            break;
        }
        case 2: {
            if ([DynamicUIService service].fontSize == ApplicationFontBig) {
                return;
            }
            [[DynamicUIService service] saveCurrentFontSize:ApplicationFontBig];
            break;
        }
    }
    [AppHelper updateFontsOnTabBar];
    [self updateColorForDescriptioveTextSize];
}

#pragma mark - SegmentViewDelegate

- (void)segmentControlDidPressedItem:(NSUInteger)item inSegment:(SegmentView *)segment
{
    switch (segment.segmentTag) {
        case 1: {
            [self languageSegmentControllerPressed:item];
            break;
        }
    }
}

#pragma mark - Private

- (void)prepareUISwitchSettingViewController
{
    [self.themeColorBlackAndWhiteSwitch addTarget:self action:@selector(selectThemeColorBlackAndWhiteSwitch:) forControlEvents:UIControlEventValueChanged];

    [self prepareUISwitch:self.themeColorBlackAndWhiteSwitch];
    [self prepareUISwitch:self.appTutorialScreensSwitch];
    [self prepareUISwitch:self.screenLockNotificationSwitch];
}

- (void)prepareUISwitch:(UISwitch *) prepareSwitch
{
    prepareSwitch.backgroundColor = [UIColor grayBorderTextFieldTextColor];
    prepareSwitch.layer.cornerRadius = 16.0f;
    prepareSwitch.tintColor = [UIColor grayBorderTextFieldTextColor];
}

- (void)transformUILayer:(CATransform3D)animCATransform3D
{
    self.conteinerView.layer.transform = animCATransform3D;
    
    self.conteinerButtonColorThemeView.layer.transform = animCATransform3D;
    self.languageSegmentControl.layer.transform = animCATransform3D;
    
    self.languageLabel.layer.transform = animCATransform3D;
    self.fontSizeLabel.layer.transform = animCATransform3D;
    self.colorImpairedLabel.layer.transform = animCATransform3D;
    self.screenLockNotificationTitleLabel.layer.transform = animCATransform3D;
    self.screenLockNotificationDetailsLabel.layer.transform = animCATransform3D;
    self.appTutorialScreensTitleLabel.layer.transform = animCATransform3D;
    self.appTutorialScreensDetailsLabel.layer.transform = animCATransform3D;
    self.colorThemeTitleLabel.layer.transform = animCATransform3D;
    self.colorThemeDetailsLabel.layer.transform = animCATransform3D;
    self.aboutTRATitleLabel.layer.transform = animCATransform3D;
    self.aboutTRADetailsLabel.layer.transform = animCATransform3D;
    self.leftFontSizeLabel.layer.transform = animCATransform3D;
    self.centerFontSizeLabel.layer.transform = animCATransform3D;
    self.rightFontSizeLabel.layer.transform = animCATransform3D;
    self.slider.layer.transform = animCATransform3D;
}

- (void)setTextAligmentLabelSettingViewController:(NSTextAlignment)textAlignment
{
    self.languageLabel.textAlignment = textAlignment;
    self.fontSizeLabel.textAlignment = textAlignment;
    self.colorImpairedLabel.textAlignment = textAlignment;
    self.screenLockNotificationTitleLabel.textAlignment = textAlignment;
    self.screenLockNotificationDetailsLabel.textAlignment = textAlignment;
    self.appTutorialScreensTitleLabel.textAlignment = textAlignment;
    self.appTutorialScreensDetailsLabel.textAlignment = textAlignment;
    self.colorThemeTitleLabel.textAlignment = textAlignment;
    self.colorThemeDetailsLabel.textAlignment = textAlignment;
    self.aboutTRATitleLabel.textAlignment = textAlignment;
    self.aboutTRADetailsLabel.textAlignment = textAlignment;
    self.rightFontSizeLabel.textAlignment = textAlignment == NSTextAlignmentLeft ? NSTextAlignmentRight : NSTextAlignmentLeft;
    self.leftFontSizeLabel.textAlignment = textAlignment;
}

- (void)transformAnimationConteinerView
{
    CAKeyframeAnimation * transformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnim.values = @[[NSValue valueWithCATransform3D : [DynamicUIService service].language == LanguageTypeArabic ? CATransform3DMakeScale(-1, 1, 1) : CATransform3DIdentity],
                             [NSValue valueWithCATransform3D : [DynamicUIService service].language == LanguageTypeArabic ? CATransform3DIdentity : CATransform3DMakeScale(-1, 1, 1)]];
    transformAnim.duration = 0.4;
    [self.conteinerView.layer addAnimation:transformAnim forKey:@"transformView"];
}

- (void)selectColorTheme:(NSInteger)numberTheme
{
    switch (numberTheme) {
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

- (void)makeActiveColorTheme:(ApplicationColor)selectedColor
{
    [self.themeBlueButton setImage:[UIImage imageNamed:@"btn_theme_bl"] forState:UIControlStateNormal];
    [self.themeOrangeButton setImage:[UIImage imageNamed:@"btn_theme_rng"] forState:UIControlStateNormal];
    [self.themeGreenButton setImage:[UIImage imageNamed:@"btn_theme_grn"] forState:UIControlStateNormal];
    self.themeColorBlackAndWhiteSwitch.on = NO;
    
    [[DynamicUIService service] setColorScheme:selectedColor];
    
    switch (selectedColor) {
        case ApplicationColorDefault:
        case ApplicationColorBlue: {
            [self.themeBlueButton setImage:[UIImage imageNamed:@"btn_theme_bl_act"] forState:UIControlStateNormal];
            break;
        }
        case ApplicationColorOrange: {
            [self.themeOrangeButton setImage:[UIImage imageNamed:@"btn_theme_rng_act"] forState:UIControlStateNormal];
            break;
        }
        case ApplicationColorGreen: {
            [self.themeGreenButton setImage:[UIImage imageNamed:@"btn_theme_grn_act"] forState:UIControlStateNormal];
            break;
        }
        case ApplicationColorBlackAndWhite: {
            self.themeColorBlackAndWhiteSwitch.on = YES;
            break;
        }
    }
    
    [self updateColors];
}

- (void)prepareNavigationBar
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)setPrepareTitleLabel:(NSString *)title
{
    UILabel *titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = title;
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.font = [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:14.f] : [UIFont latoRegularWithSize:14.f];
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.leftFontSizeLabel.text = dynamicLocalizedString(@"settings.label.fontsize.description.small");
    self.centerFontSizeLabel.text = dynamicLocalizedString(@"settings.label.fontsize.description.normal");
    self.rightFontSizeLabel.text = dynamicLocalizedString(@"settings.label.fontsize.description.large");
    
    [self setPrepareTitleLabel:dynamicLocalizedString(@"settings.title")];
    self.languageLabel.text = dynamicLocalizedString(@"settings.label.language");
    self.fontSizeLabel.text = dynamicLocalizedString(@"settings.label.fontsize");
    self.colorImpairedLabel.text = dynamicLocalizedString(@"settings.label.colorImpaired");
    self.screenLockNotificationTitleLabel.text = dynamicLocalizedString(@"settings.label.screenLockNotificationTitle");
    self.screenLockNotificationDetailsLabel.text = dynamicLocalizedString(@"settings.label.screenLockNotificationDetauils");
    self.appTutorialScreensTitleLabel.text = dynamicLocalizedString(@"settings.label.appTutorialScreensTitle");
    self.appTutorialScreensDetailsLabel.text = dynamicLocalizedString(@"settings.label.appTutorialScreensDetails");
    self.colorThemeTitleLabel.text = dynamicLocalizedString(@"settings.label.colorThemeTitle");
    self.colorThemeDetailsLabel.text = dynamicLocalizedString(@"settings.label.colorThemeDetails");
    self.aboutTRATitleLabel.text = dynamicLocalizedString(@"settings.label.aboutTRATitle");
    self.aboutTRADetailsLabel.text = dynamicLocalizedString(@"settings.label.aboutTRADetails");
    
    self.languageSegmentControl.segmentItems = @[dynamicLocalizedString(@"settings.switchControl.language.arabic"), dynamicLocalizedString(@"setting.switchControl.language.english")];
}

- (void)updateColors
{
    self.screenLockNotificationSwitch.onTintColor = [[DynamicUIService service] currentApplicationColor];
    self.appTutorialScreensSwitch.onTintColor = [[DynamicUIService service] currentApplicationColor];
    self.themeColorBlackAndWhiteSwitch.onTintColor = [[DynamicUIService service] currentApplicationColor];
    
    self.languageSegmentControl.segmentSelectedBacrgroundColor = [[DynamicUIService service] currentApplicationColor];
    [self.languageSegmentControl setNeedsLayout];
    [self updateFontSizeSliderColor];
    [self updateColorForDescriptioveTextSize];
}

- (void)setRTLArabicUI
{
    [self transformUILayer:CATransform3DMakeScale(-1, 1, 1)];
    
    self.screenLockNotificationSwitch.layer.transform = CATransform3DMakeScale(- optionScaleSwitch, optionScaleSwitch, 1);
    self.appTutorialScreensSwitch.layer.transform = CATransform3DMakeScale(- optionScaleSwitch, optionScaleSwitch, 1);
    self.themeColorBlackAndWhiteSwitch.layer.transform = CATransform3DMakeScale(- optionScaleSwitch, optionScaleSwitch, 1);
    
    [self setTextAligmentLabelSettingViewController:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [self transformUILayer:CATransform3DIdentity];
    
    self.screenLockNotificationSwitch.layer.transform = CATransform3DMakeScale(optionScaleSwitch, optionScaleSwitch, 1);
    self.appTutorialScreensSwitch.layer.transform = CATransform3DMakeScale(optionScaleSwitch, optionScaleSwitch, 1);
    self.themeColorBlackAndWhiteSwitch.layer.transform = CATransform3DMakeScale(optionScaleSwitch, optionScaleSwitch, 1);
    
    [self setTextAligmentLabelSettingViewController:NSTextAlignmentLeft];
}

#pragma mark - UIUpdate

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

- (void)updateFontSizeControl
{
    switch ([DynamicUIService service].fontSize) {
        case ApplicationFontUndefined: {
            [self.slider setValue:1];
            break;
        }
        case ApplicationFontSmall: {
            [self.slider setValue:0];
            break;
        }
        case ApplicationFontBig: {
            [self.slider setValue:2];
            break;
        }
    }
}

- (void)prepareSegmentsView
{
    self.languageSegmentControl.delegate = self;
    self.languageSegmentControl.segmentItemsAttributes = @[@{NSFontAttributeName : [UIFont droidKufiBoldFontForSize:12]}, @{NSFontAttributeName : [UIFont latoBoldWithSize:12]}];
}

- (void)setCurrentColorThemaUserDefaults:(NSInteger)currentNumberColorTheme
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:currentNumberColorTheme forKey:@"currentNumberColorTheme"];
}

- (NSInteger)currentColorThemaUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger result = (NSInteger) [userDefaults integerForKey:@"currentNumberColorTheme"];
    return result;
}

#pragma mark - Slider Setup

- (void)prepareFontSizeSlider
{
    UIImage *img = [UIImage imageNamed:@"filled13-2"];
    [self.slider setThumbImage:img forState:UIControlStateNormal];
    [self.slider setThumbImage:img forState:UIControlStateSelected];
    [self.slider setThumbImage:img forState:UIControlStateHighlighted];
}

- (void)updateFontSizeSliderColor
{
    UIImage *currentSliderMaximumImage = self.slider.currentMaximumTrackImage;
    
    CGRect rect = CGRectMake(0, 0, currentSliderMaximumImage.size.width, currentSliderMaximumImage.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [[[DynamicUIService service] currentApplicationColor] setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.slider setMaximumTrackImage:image forState:UIControlStateNormal];
    
    [self.slider setMinimumTrackImage:image forState:UIControlStateNormal];
    
    [[UISlider appearance] setTintColor:[UIColor itemGradientTopColor]];
    
    for (UIView *point in self.containerSliderView.subviews) {
        if (![point isKindOfClass:[UISlider class]]) {
            point.layer.cornerRadius = point.frame.size.height / 2;
            point.backgroundColor = [[DynamicUIService service] currentApplicationColor];
        }
    }
}

- (void)updateColorForDescriptioveTextSize
{
    UIColor *textColor = [[DynamicUIService service] currentApplicationColor];
    
    self.rightFontSizeLabel.textColor = [UIColor lightGraySettingTextColor];
    self.leftFontSizeLabel.textColor = [UIColor lightGraySettingTextColor];
    self.centerFontSizeLabel.textColor = [UIColor lightGraySettingTextColor];
    
    switch ([DynamicUIService service].fontSize) {
        case ApplicationFontUndefined: {
            self.centerFontSizeLabel.textColor = textColor;
            break;
        }
        case ApplicationFontSmall: {
            self.leftFontSizeLabel.textColor = textColor;
            break;
        }
        case ApplicationFontBig: {
            self.rightFontSizeLabel.textColor = textColor;
            break;
        }
    }
}

@end
