//
//  ListOfDevicesViewController.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

#import "ListOfDevicesViewController.h"
#import "ListOfDevicesTableViewCell.h"

@interface ListOfDevicesViewController ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ListOfDevicesViewController

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
    
    ListOfDevicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListOfDevicesCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107.f;
}

- (void)configureCell:(ListOfDevicesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        cell.marginContainerCellConstraint.constant = 16.f;
    } else {
        cell.marginContainerCellConstraint.constant = 45.f;
    }
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
