//
//  LoginViewController.h
//  TRA Smart Services
//
//  Created by Admin on 20.07.15.
//
#import "BaseMembershipViewController.h"

@interface LoginViewController : BaseMembershipViewController

@property (strong, nonatomic) void (^didCloseViewController)();
@property (strong, nonatomic) void (^didDismissed)();
@property (assign, nonatomic) BOOL shouldAutoCloseAfterLogin;

@end
