//
//  BaseMembershipViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "UINavigationController+Transparent.h"
#import "UINavigationController+TopButton.h"
#import "OffsetTextField.h"

@interface BaseMembershipViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidLoad;

- (void)prepareNavigationBar;

@end
