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

- (void)testSaveCredentials
{
    NSString *password = @"password";
    NSString *userName = @"userName";
    [self.storage storePassword:password forUser:userName];
    
    NSDictionary *storedCredentials = [self.storage credentialsForLoginedUser];
    
    XCTAssertEqualObjects([storedCredentials valueForKey:KeychainStorageKeyLogin], userName, @"Stored userName incorrect");
    XCTAssertEqualObjects([storedCredentials valueForKey:KeychainStorageKeyPassword], password, @"Stored password incorrect");
}

//- (void)testRemoveStoredCredentials

@end
