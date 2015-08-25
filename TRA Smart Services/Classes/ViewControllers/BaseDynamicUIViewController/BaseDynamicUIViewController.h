//
//  BaseDynamicUIViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 01.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface BaseDynamicUIViewController : UIViewController <UITextFieldDelegate>

- (void)updateSubviewForParentViewIfPossible:(UIView *)mainView fontSizeInclude:(BOOL)includeFontSizeChange;
- (void)localizeUI;
- (void)updateColors;

- (void)setRTLArabicUI;
- (void)setLTREuropeUI;

@end
