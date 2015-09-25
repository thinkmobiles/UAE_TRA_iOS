//
//  AutoLoginService.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 22.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "AutoLoginService.h"
#import "KeychainStorage.h"

@interface AutoLoginService()

@property (strong, nonatomic) KeychainStorage *keychain;

@end

@implementation AutoLoginService

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _keychain = [[KeychainStorage alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)performAutoLoginIfPossible
{
    if ([self isAutoLoginPossible]) {
        NSDictionary *userCredentials = [self.keychain credentialsForLoginedUser];
        
        [AppHelper showLoaderWithText:dynamicLocalizedString(@"autoLogin.message")];
        [[NetworkManager sharedManager] traSSLoginUsername:[userCredentials valueForKey:KeychainStorageKeyLogin] password:[userCredentials valueForKey:KeychainStorageKeyPassword] requestResult:^(id response, NSError *error) {
            [AppHelper hideLoader];
        }];
    }
}

- (void)performAutoLoginWithPassword:(NSString *)userPassword
{
    if ([self isAutoLoginPossible]) {
        NSString *userName = [KeychainStorage userName];
        [AppHelper showLoaderWithText:dynamicLocalizedString(@"autoLogin.message")];

        [[NetworkManager sharedManager] traSSLoginUsername:userName password:userPassword requestResult:^(id response, NSError *error) {
            [AppHelper hideLoader];
            if (error) {
                [AppHelper alertViewWithMessage:response];
            }
        }];
    }
}

#pragma mark - Private

- (BOOL)isAutoLoginPossible
{
    BOOL possible = NO;
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:UserNameKey];
    if (userName.length) {
        possible = YES;
    }
    return possible;
}

@end
