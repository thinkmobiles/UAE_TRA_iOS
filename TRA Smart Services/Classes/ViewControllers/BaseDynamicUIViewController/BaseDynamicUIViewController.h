//
//  BaseDynamicUIViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 01.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface BaseDynamicUIViewController : UIViewController

- (void)updateSubviewForParentViewIfPossible:(UIView *)mainView;
- (void)localizeUI;
- (void)updateColors;

@end
