//
//  FingerPrintAuth.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "FingerPrintAuth.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation FingerPrintAuth

- (void)authentificationsWithTouch
{
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
    } else {
        
    }
    
    
}

@end
