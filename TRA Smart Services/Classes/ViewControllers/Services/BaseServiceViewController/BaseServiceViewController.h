//
//  BaseServiceViewController.h
//  TRA Smart Services
//
//  Created by Admin on 31.08.15.
//

#import "BottomBorderTextField.h"
#import "BottomBorderTextView.h"

@interface BaseServiceViewController : BaseDynamicUIViewController

@property (assign, nonatomic) NSInteger serviceID;

- (void)presentLoginIfNeededAndPopToRootController:(UIViewController *)controller;
- (void)updateColors;
- (void)configureKeyboardButtonDone:(UITextView *)textView;

@end