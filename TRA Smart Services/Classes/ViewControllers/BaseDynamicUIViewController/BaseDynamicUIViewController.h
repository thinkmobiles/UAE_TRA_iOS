//
//  BaseDynamicUIViewController.h
//  TRA Smart Services
//
//  Created by Admin on 01.08.15.
//

static CGFloat const DeclineTagForFontUpdate = 2000;

static NSString *const PreviousFontSizeKey = @"PreviousFontSizeKey";

static NSString *const DefaultLogoImageName = @"ic_logo_us";

@interface BaseDynamicUIViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) DynamicUIService *dynamicService;

- (void)updateSubviewForParentViewIfPossible:(UIView *)mainView fontSizeInclude:(BOOL)includeFontSizeChange;
- (void)updateBackgroundImageNamed:(NSString *)imageName;

- (void)localizeUI;
- (void)updateColors;

- (void)setRTLArabicUI;
- (void)setLTREuropeUI;

@end
