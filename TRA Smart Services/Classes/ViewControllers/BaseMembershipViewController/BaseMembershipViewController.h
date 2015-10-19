//
//  BaseMembershipViewController.h
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#import "UINavigationController+Transparent.h"
#import "UINavigationController+TopButton.h"
#import "OffsetTextField.h"
#import "LeftInsetTextField.h"

static NSString *const CloseButtonImageName = @"btn_close";

@interface BaseMembershipViewController : BaseDynamicUIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;

- (void)prepareNavigationBar;
- (void)returnKeyDone;

- (void)configureTextField:(LeftInsetTextField *)textField withImageName:(NSString *)imageName;

@end
