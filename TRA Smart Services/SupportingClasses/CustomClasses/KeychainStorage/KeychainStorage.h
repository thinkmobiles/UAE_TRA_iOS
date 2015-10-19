//
//  KeychainStorage.h
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#import "UserModel.h"


static NSString *const userModelKey = @"UserModel";
static NSString *const UserNameKey = @"userNameKey";

static NSString *const KeychainStorageKeyLogin = @"KeychainStorageKeyLogin";
static NSString *const KeychainStorageKeyPassword = @"KeychainStorageKeyPassword";

@interface KeychainStorage : NSObject

- (void)storePassword:(NSString *)password forUser:(NSString *)userName;
- (void)removeStoredCredentials;
- (NSDictionary *)credentialsForLoginedUser;

- (void)saveCustomObject:(id)object key:(NSString *)key;
- (id)loadCustomObjectWithKey:(NSString *)key;

+ (NSString *)userName;

@end