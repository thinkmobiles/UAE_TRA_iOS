//
//  ListOfMobileBrandViewController.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 29.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "ListOfMobileBrandViewController.h"
#import "ListOfMobileBrandTableViewCell.h"

@interface ListOfMobileBrandViewController ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ListOfMobileBrandViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
    [self prepareDataSource];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ListOfMobileBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListOfMobileBrandCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.f;
}

- (void)configureCell:(ListOfMobileBrandTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *element = self.dataSource[indexPath.row];
    UIImage *logo = [UIImage imageNamed:[element valueForKey:@"logoBrand"]];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.logoBrandImageView.image = logo;
    
    UIImage *iconImage = [UIImage imageNamed:[element valueForKey:@"iconHexagone"]];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        iconImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:iconImage];
    }
    cell.deviceHexagonImageView.image = iconImage;

    if (indexPath.row % 2) {
        cell.marginContainerCellConstraint.constant = 16.f;
    } else {
        cell.marginContainerCellConstraint.constant = 35.f;
    }
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"listOfMobileBrandViewController.title");
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

#pragma mark - Private

- (void)prepareDataSource
{
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MobileBrandList" ofType:@"plist"]];
}

@end
