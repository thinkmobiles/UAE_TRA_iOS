//
//  FavouriteViewControllerTests.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BaseDynamicUIViewController.h"
#include <objc/runtime.h>
#import "FavouriteViewController.h"

@interface FavouriteViewControllerTests : XCTestCase

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FavouriteViewController *favViewController;

@end

@implementation FavouriteViewControllerTests

#pragma mark - LifeCycle

- (void)setUp
{
    [super setUp];
    
    self.favViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:NSClassFromString(@"FavouriteViewController")]] instantiateViewControllerWithIdentifier:@"favViewControllerID"];
    objc_property_t tableView = class_getProperty([self.favViewController class], "tableView");
    self.tableView = (__bridge UITableView *)(tableView);
}

- (void)tearDown
{
    [super tearDown];
    
    self.tableView = nil;
    self.favViewController = nil;
}

#pragma mark - Tests

#pragma mark - PropertiesTest

- (void)testFavouriteViewControllerHasAPropertyTableView
{
    objc_property_t tableView = class_getProperty([self.favViewController class], "tableView");
    self.tableView = (__bridge UITableView *)(tableView);
    
    XCTAssert(self.tableView != nil);
}

- (void)testFavouriteViewControllerHasAPropertyDataSource
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "dataSource");
    XCTAssert(dataSource != NULL);
}

- (void)testFavouriteViewControllerHasAPropertyFilteredDataSource
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "filteredDataSource");
    XCTAssert(dataSource != NULL);
}

- (void)testFavouriteViewControllerHasAManagedObjectContextProperty
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "managedObjectContext");
    XCTAssert(dataSource != NULL);
}

- (void)testFavouriteViewControllerHasAManagedObjectModelProperty
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "managedObjectModel");
    XCTAssert(dataSource != NULL);
}

- (void)testFavouriteViewControllerHasARemoveProcessIsActiveProperty
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "removeProcessIsActive");
    XCTAssert(dataSource != NULL);
}

- (void)testFavouriteViewControllerHasAArcDeleteZoneLayerProperty
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "arcDeleteZoneLayer");
    XCTAssert(dataSource != NULL);
}

- (void)testFavouriteViewControllerHasAContentFakeIconLayerProperty
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "contentFakeIconLayer");
    XCTAssert(dataSource != NULL);
}

- (void)testFavouriteViewControllerHasAShadowFakeIconLayerProperty
{
    objc_property_t dataSource = class_getProperty([FavouriteViewController class], "shadowFakeIconLayer");
    XCTAssert(dataSource != NULL);
}


@end
