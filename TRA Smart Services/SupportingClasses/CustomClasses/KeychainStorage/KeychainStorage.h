//
//  KeychainStorage.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 21.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

static NSString *const UserNameKey = @"userNameKey";

static NSString *const KeychainStorageKeyLogin = @"KeychainStorageKeyLogin";
static NSString *const KeychainStorageKeyPassword = @"KeychainStorageKeyPassword";

@interface KeychainStorage : NSObject

- (void)storePassword:(NSString *)password forUser:(NSString *)userName;
- (void)removeStoredCredentials;
- (NSDictionary *)credentialsForLoginedUser;

+ (NSString *)userName;

@end