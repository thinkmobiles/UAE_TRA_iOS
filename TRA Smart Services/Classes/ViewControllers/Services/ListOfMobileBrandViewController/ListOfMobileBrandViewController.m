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
    if (indexPath.row % 2) {
        cell.marginContainerCellConstraint.constant = 16.f;
    } else {
        cell.marginContainerCellConstraint.constant = 35.f;
    }
//    cell.logoBrandImageView.image =
//    cell.deviceHexagonImageView.image =
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

@end
