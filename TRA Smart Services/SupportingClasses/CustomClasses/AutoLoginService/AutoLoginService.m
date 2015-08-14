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

#pragma mark - Public

- (void)performAutoLoginIfPossible
{
    if ([self isAutoLoginPossible]) {
      //  NSDictionary *userCredentials = [self.keychain credentialsForLoginedUser];
        //todo autologin to server CRM
    }
}

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self baseInitialization];
    }
    return self;
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

- (void)baseInitialization
{
    self.keychain = [[KeychainStorage alloc] init];
}

@end
