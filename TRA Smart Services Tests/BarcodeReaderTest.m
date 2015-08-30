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

@interface BarcodeReaderTest : XCTestCase

@property (strong, nonatomic) UIView *fakePlayerView;
@property (strong, nonatomic) BarcodeCodeReader *reader;

@end

@implementation BarcodeReaderTest

#pragma mark - Testing

- (void)testInitWithNilView
{
    self.reader = [[BarcodeCodeReader alloc] initWithView:self.fakePlayerView];
    XCTAssertFalse(self.reader);
}

- (void)testInitWithView
{
    self.fakePlayerView = [[UIView alloc] init];
    self.reader = [[BarcodeCodeReader alloc] initWithView:self.fakePlayerView];
    XCTAssert(self.reader);
}

@end