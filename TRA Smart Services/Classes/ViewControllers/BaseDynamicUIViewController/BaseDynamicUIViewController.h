//
//  BaseDynamicUIViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 01.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "DynamicUIService.h"

static CGFloat const DeclineTagForFontUpdate = 2000;

static NSString *const PreviousFontSizeKey = @"PreviousFontSizeKey";

@interface BaseDynamicUIViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) DynamicUIService *dynamicService;

- (void)updateSubviewForParentViewIfPossible:(UIView *)mainView fontSizeInclude:(BOOL)includeFontSizeChange;
- (void)localizeUI;
- (void)updateColors;

- (void)setRTLArabicUI;
- (void)setLTREuropeUI;

@end
