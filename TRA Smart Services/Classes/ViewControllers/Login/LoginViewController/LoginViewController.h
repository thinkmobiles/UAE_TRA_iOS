//
//  LoginViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//
#import "BaseMembershipViewController.h"

@interface LoginViewController : BaseMembershipViewController

@property (strong, nonatomic) void (^didCloseViewController)();
@property (strong, nonatomic) void (^didDismissed)();
@property (assign, nonatomic) BOOL shouldAutoCloseAfterLogin;

@end
