//
//  KeychainStorage.m
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//

#import "KeychainStorage.h"
#import <Security/Security.h>

static NSString *const UserWebSiteKey = @"com.traSmartService";

@implementation KeychainStorage

#pragma mark - Public

- (void)storePassword:(NSString *)password forUser:(NSString *)userName
{
    if (!password.length || !userName.length) {
        return;
    }
    [self saveUserLogin:userName andPassword:password];
    [self storeUserName:userName];
}

- (NSDictionary *)credentialsForLoginedUser
{
    NSDictionary *credentials;
    NSString *userLogin = [self nameForLoginedUser];
    if (userLogin.length) {
        credentials = @{
                        KeychainStorageKeyLogin : userLogin,
                        KeychainStorageKeyPassword : [self getPasswordForUserName:userLogin]
                        };
    }
    return credentials;
}

- (void)removeStoredCredentials
{
    [self deleteStoredCredentials];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userName
{
    NSString *name = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey]) {
        name = [[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey];
    }
    return name;
}

#pragma mark - Private

#pragma mark - UserDefaults

- (void)storeUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:UserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)nameForLoginedUser
{
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:UserNameKey];
    return name;
}

- (void)saveCustomObject:(id)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

- (UserModel *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    UserModel *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

#pragma mark - Keychain

- (void)saveUserLogin:(NSString *)login andPassword:(NSString *)password
{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    keychainItem[(__bridge id)kSecAttrServer] = UserWebSiteKey;
    keychainItem[(__bridge id)kSecAttrAccount] = login;
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        attributesToUpdate[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
        OSStatus sts = SecItemUpdate((__bridge CFDictionaryRef)keychainItem, (__bridge CFDictionaryRef)attributesToUpdate);
        DLog(@"Password Updated - Error Code: %d", (int)sts);
    } else {
        keychainItem[(__bridge id)kSecValueData] = [password dataUsingEncoding:NSUTF8StringEncoding];
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        DLog(@"Password saved - Error Code: %d", (int)sts);
    }
}

- (NSString *)getPasswordForUserName:(NSString *)userName
{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    keychainItem[(__bridge id)kSecAttrServer] = UserWebSiteKey;
    keychainItem[(__bridge id)kSecAttrAccount] = userName;
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef result = nil;
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    DLog(@"Password Get - Error Code: %d", (int)sts);
    NSString *password;
    if(sts == noErr) {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
        NSData *pswd = resultDict[(__bridge id)kSecValueData];
        password = [[NSString alloc] initWithData:pswd encoding:NSUTF8StringEncoding];
    }
    return password;
}

- (void)deleteStoredCredentials
{
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    NSString *userLogin = [self nameForLoginedUser];

    if (!userLogin.length) {
        return;
    }
    
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassInternetPassword;
    keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
    keychainItem[(__bridge id)kSecAttrServer] = UserWebSiteKey;
    keychainItem[(__bridge id)kSecAttrAccount] = userLogin;
    
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL) == noErr) {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
        DLog(@"Password delete - Error Code: %d", (int)sts);
    }
}

@end
