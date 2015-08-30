//
//  KeychainTest.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 29.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "KeychainStorage.h"

@interface KeychainTest : XCTestCase

@property (strong, nonatomic) KeychainStorage *storage;

@end

@implementation KeychainTest

#pragma mark - LifeCycle

- (void)setUp
{
    [super setUp];
 
    self.storage = [[KeychainStorage alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Testing

- (void)testCreating
{
    XCTAssertNotNil(self.storage, @"Cant create storage Object");
}

- (void)testSaveAndRetriveCredentials
{
    NSString *password = @"password";
    NSString *userName = @"userName";
    [self.storage storePassword:password forUser:userName];
    NSDictionary *storedCredentials = [self.storage credentialsForLoginedUser];
    
    XCTAssertEqualObjects([storedCredentials valueForKey:KeychainStorageKeyLogin], userName, @"Stored userName incorrect");
    XCTAssertEqualObjects([storedCredentials valueForKey:KeychainStorageKeyPassword], password, @"Stored password incorrect");
}

- (void)testRemoveStoredCredentials
{
    [self.storage removeStoredCredentials];
    
    NSDictionary *storedCredentials = [self.storage credentialsForLoginedUser];
    XCTAssertNil(storedCredentials, @"Stored credentials is not deleted");
}

- (void)testIncorrectParametersStorage
{
    NSString *password = @"";
    NSString *userName = @"";
    [self.storage removeStoredCredentials]; //clean up prev tests
    [self.storage storePassword:password forUser:userName];
    NSDictionary *storedCredentials = [self.storage credentialsForLoginedUser];
    XCTAssertEqualObjects(storedCredentials, nil, @"Stored incorrect parameters");
}

- (void)testUpdateCredentials
{
    [self testSaveAndRetriveCredentials];
    
    NSString *password = @"newPassword";
    NSString *userName = @"userName";
    [self.storage storePassword:password forUser:userName];
    NSDictionary *storedCredentials = [self.storage credentialsForLoginedUser];
    
    XCTAssertEqualObjects([storedCredentials valueForKey:KeychainStorageKeyLogin], userName, @"Stored userName incorrect");
    XCTAssertEqualObjects([storedCredentials valueForKey:KeychainStorageKeyPassword], password, @"Stored password incorrect");
}

@end
