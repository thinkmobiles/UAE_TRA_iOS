//
//  FavouriteViewControllerTests.m
//  TRA Smart Services
//
//  Created by Admin on 31.08.15.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#include <objc/runtime.h>
#import "FavouriteViewController.h"

@interface FavouriteViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface FavouriteViewControllerTests : XCTestCase

@property (strong, nonatomic) FavouriteViewController *favViewController;

@end

@implementation FavouriteViewControllerTests

#pragma mark - LifeCycle

- (void)setUp
{
    [super setUp];
    
    self.favViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:NSClassFromString(@"FavouriteViewController")]] instantiateViewControllerWithIdentifier:@"favViewControllerID"];
}

- (void)tearDown
{
    [super tearDown];
    
    self.favViewController = nil;
}

#pragma mark - Tests

#pragma mark - Properties

- (void)testFavouriteViewControllerHasAPropertyTableView
{
    objc_property_t tableView = class_getProperty([self.favViewController class], "tableView");
    XCTAssert(tableView != NULL);
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