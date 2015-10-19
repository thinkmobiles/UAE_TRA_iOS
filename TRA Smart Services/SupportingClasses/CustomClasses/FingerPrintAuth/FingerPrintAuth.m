//
//  FingerPrintAuth.m
//  TRA Smart Services
//
//  Created by Admin on 21.09.15.
//

#import "FingerPrintAuth.h"
#import "AutoLoginService.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface FingerPrintAuth()

@property (strong, nonatomic) AutoLoginService *service;

@end

@implementation FingerPrintAuth

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.service = [[AutoLoginService alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)authentificationsWithTouch
{
    LAContext *context = [[LAContext alloc] init];
    context.maxBiometryFailures = @(2);
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        __weak typeof(self) weakSelf = self;
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:dynamicLocalizedString(@"fingerPrintService.DescriptionReason") reply:^(BOOL success, NSError * _Nullable error) {
            if (error) {
#if DEBUG
                [weakSelf handleEvaluatePolicyError:error];
#endif
                [weakSelf showAlertWithPasswordField];
            } else if (success) {
                [weakSelf.service performAutoLoginIfPossible];
            } else {
                [weakSelf showAlertWithPasswordField];
            }
        }];
    } else {
#if DEBUG
        [self handleAccessError:error];
#endif
        [self showAlertWithPasswordField];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        if ([alertView textFieldAtIndex:0].text.length) {
            [self performAutologinWithPassword:[alertView textFieldAtIndex:0].text];
        } else {
            [self showAlertWithPasswordField];
        }
    }
}

#pragma mark - Private

- (void)performAutologinWithPassword:(NSString *)userPassword
{
    [self.service performAutoLoginWithPassword:userPassword];
}

- (void)showAlertWithPasswordField
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:[AppHelper appName] message:dynamicLocalizedString(@"fingerPrintService.passwordRequest.message") delegate:self cancelButtonTitle:dynamicLocalizedString(@"fingerPrintService.CancelAuth.title") otherButtonTitles: dynamicLocalizedString(@"fingerPrintService.ConfirmPassword.title"), nil];
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alertView show];
    });
}

#pragma mark - Error Handling

- (void)handleEvaluatePolicyError:(NSError *)error
{
    switch (error.code) {
        case LAErrorSystemCancel: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"fingerPrintService.LoginCanceledBySystem")];
            break;
        }
        case LAErrorUserFallback: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"fingerPrintService.LoginCanceledByUser")];
            break;
        }
        case LAErrorAuthenticationFailed: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"fingerPrintService.InvalidFingerPrint")];
            break;
        }
        case LAErrorUserCancel: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"fingerPrintService.LoginCanceledByUser")];
            break;
        }
    }
}

- (void)handleAccessError:(NSError *)error
{
    switch (error.code) {
        case LAErrorTouchIDNotEnrolled: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"fingerPrintService.TouchIDNotEnrolled")];
            break;
        }
        case LAErrorTouchIDNotAvailable: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"fingerPrintService.TouchIdNotAvaliable")];
            break;
        }
        case LAErrorTouchIDLockout: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"fingerPrintService.PasscodeHasNotBeenSet")];
            break;
        }
    }
}

@end