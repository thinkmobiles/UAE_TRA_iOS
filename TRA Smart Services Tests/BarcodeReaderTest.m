//
//  BarcodeReaderTest.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 30.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BarcodeCodeReader.h"

@interface BarcodeReaderTest : XCTestCase <BarcodeCodeReaderDelegate>

@property (strong, nonatomic) UIView *fakePlayerView;
@property (strong, nonatomic) BarcodeCodeReader *reader;

@end

@implementation BarcodeReaderTest

#pragma mark - LifeCycle

- (void)setUp
{
    [super setUp];
    
    self.fakePlayerView = [[UIView alloc] init];
    self.reader = [[BarcodeCodeReader alloc] initWithView:self.fakePlayerView];
    self.reader.delegate = self;
}

- (void)tearDown
{
    [super tearDown];
    
    self.fakePlayerView = nil;
    self.reader = nil;
    self.reader.delegate = nil;
}

#pragma mark - BarcodeCodeReaderDelegate

- (void)readerDidFinishCapturingWithResult:(NSString *)result
{
    //dummy
}

#pragma mark - Testing

- (void)testInitWithNilView
{
    self.reader = nil;
    self.reader = [[BarcodeCodeReader alloc] initWithView:nil];
    XCTAssertFalse(self.reader);
}

- (void)testInitWithView
{
    self.reader = nil;
    self.reader = [[BarcodeCodeReader alloc] initWithView:self.fakePlayerView];
    XCTAssert(self.reader);
}

- (void)testDelegateExisting
{
    XCTAssert(self.reader.delegate);
}

- (void)testConformalForDelegate
{
    XCTAssert([self.reader.delegate conformsToProtocol:@protocol(BarcodeCodeReaderDelegate)]);
}

- (void)testDelegateNilUsage
{
    XCTAssertNoThrow(self.reader.delegate = nil);
}

- (void)testConformingObjectCanBeDelegate
{
    id <BarcodeCodeReaderDelegate> delegate = self;
    XCTAssertNoThrow(self.reader.delegate = delegate);
}

- (void)testDelegateResponse
{
    XCTAssertFalse(self.reader.delegate && [self.reader.delegate respondsToSelector:@selector(readerDidChangeStatusTo:)]);
    XCTAssert(self.reader.delegate && [self.reader.delegate respondsToSelector:@selector(readerDidFinishCapturingWithResult:)]);
}

@end