//
//  BaseServiceViewController.h
//  TRA Smart Services
//
//  Created by Admin on 31.08.15.
//

#import "BottomBorderTextField.h"
#import "BottomBorderTextView.h"

@interface BaseServiceViewController : BaseDynamicUIViewController

- (void)presentLoginIfNeededAndPopToRootController:(UIViewController *)controller;
- (void)updateColors;

@end