//
//  VerificationWithRegularTest.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 30.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSString+Validation.h"

@interface VerificationWithRegularTest : XCTestCase

@end

@implementation VerificationWithRegularTest

- (void)setUp
{
    [super setUp];

}

- (void)testValidationIsEmailValid
{
    NSString *testEmail = @"test@sdfs.com";
    XCTAssert([testEmail isValidEmailUseHardFilter:NO]);
    XCTAssert([testEmail isValidEmailUseHardFilter:YES]);
    testEmail = @"tes.t@sdf.s.com";
    XCTAssert([testEmail isValidEmailUseHardFilter:NO]);
    XCTAssert([testEmail isValidEmailUseHardFilter:YES]);
}

- (void)testValidationIsEmailInValid
{
    NSString *testEmail = @"test///sdfs.com";
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:NO]);
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:YES]);
    testEmail = @"test/@/sdfs.com";
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:NO]);
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:YES]);
    testEmail = @"@.com";
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:NO]);
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:YES]);
    testEmail = @"test@??sdfs.com";
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:NO]);
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:YES]);
    testEmail = @"test@sdfs.@com";
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:NO]);
    XCTAssertFalse([testEmail isValidEmailUseHardFilter:YES]);

}

- (void)testValidationISIDEmiratesValid
{
    NSString *emiratesID = @"777-7777-8888888-3";
    XCTAssert([emiratesID isValidIDEmirates]);
}

- (void)testValidationISIDEmiratesInValid
{
    NSString *emiratesID = @"e77-7777-8888888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"7787-7777-8888888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775-74777-8888888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775-74d77-8888888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775-7777-888d8888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775-74777-888888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775-74777-8888888-f";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775 74777-8888888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775-74777 8888888-3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"775 74777 8888888 3";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"sdfdsfdfsf";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
    emiratesID = @"7755747775888888853";
    XCTAssertFalse([emiratesID isValidIDEmirates]);
}

- (void)testValidationIsNameValid
{
    NSString *name = @"Artur";
    XCTAssert([name isValidName]);
    name = @"Genna";
    XCTAssert([name isValidName]);
    name = @"JohnTest";
    XCTAssert([name isValidName]);
}

- (void)testValidationIsNameInValid
{
    NSString *name = @"Artur007";
    XCTAssertFalse([name isValidName]);
    name = @"Genna-Krocodilªºªº•";
    XCTAssertFalse([name isValidName]);
    name = @"JohnTest:)";
    XCTAssertFalse([name isValidName]);
    name = @"¢∞§¢";
    XCTAssertFalse([name isValidName]);
}

- (void)testValidationIsURlValid
{
    NSString *urlToCheck = @"http://stackoverflow.com/questions/";
    XCTAssert([urlToCheck isValidURL]);
    urlToCheck = @"https://docs.google.com/sp";
    XCTAssert([urlToCheck isValidURL]);
    urlToCheck = @"http://jsonviewer.stack.hu";
    XCTAssert([urlToCheck isValidURL]);
    urlToCheck = @"http://192.168.12.234";
    XCTAssert([urlToCheck isValidURL]);
}

- (void)testValidationIsURlInValid
{
    NSString *urlToCheck = @"url";
    XCTAssertFalse([urlToCheck isValidURL]);
    urlToCheck = @"url.com.ds";
    XCTAssertFalse([urlToCheck isValidURL]);
    urlToCheck = @"http:sdfsdf.sdf.df";
    XCTAssertFalse([urlToCheck isValidURL]);
}

- (void)testValidationIsValidPhoneNumber
{
    NSString *number = @"23423234234";
    XCTAssert([number isValidPhoneNumber]);
}

- (void)testValidationIsInValidPhoneNumber
{
    NSString *number = @"2342-3234234";
    XCTAssertFalse([number isValidPhoneNumber]);
    number = @"2342dd3234234";
    XCTAssertFalse([number isValidPhoneNumber]);
    number = @"11";
    XCTAssertFalse([number isValidPhoneNumber]);
}

- (void)testValidationIsValidUserName
{
    NSString *userName = @"Jhn007";
    XCTAssert([userName isValidUserName]);
    userName = @"Jhn007-sdfs";
    XCTAssert([userName isValidUserName]);
    userName = @"Jhn0070-sdfsd09889sdfsdf";
    XCTAssert([userName isValidUserName]);
    userName = @"Jhn007dsfsdf-234dsff";
    XCTAssert([userName isValidUserName]);
}

- (void)testValidationIsInValidUserName
{
    NSString *userName = @"Jhn007?";
    XCTAssertFalse([userName isValidUserName]);
    userName = @"Jhn007!-sdfs";
    XCTAssertFalse([userName isValidUserName]);
    userName = @"Jhn0070-<>sdfsd09889sdfsdf";
    XCTAssertFalse([userName isValidUserName]);
    userName = @"J•ª•ªhn007dsfsdf-234dsff";
    XCTAssertFalse([userName isValidUserName]);
}

- (void)testValidationIsValidStateCode
{
    NSString *stateCode = @"7";
    XCTAssert([stateCode isValidStateCode]);
}

- (void)testValidationIsInValidStateCode
{
    NSString *stateCode = @"76";
    XCTAssertFalse([stateCode isValidStateCode]);
}

@end
