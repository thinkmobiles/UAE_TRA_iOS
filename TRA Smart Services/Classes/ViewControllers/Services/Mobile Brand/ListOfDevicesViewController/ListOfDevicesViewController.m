//
//  ListOfDevicesViewController.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

#import "ListOfDevicesViewController.h"
#import "ListOfDevicesTableViewCell.h"

@interface ListOfDevicesViewController()

@property (weak, nonatomic) IBOutlet UILabel *devicesNotDataLabel;

@end

@implementation ListOfDevicesViewController

#pragma mark - LifeCycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.devicesNotDataLabel.hidden = self.dataSource.count;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107.f;
}

- (void)configureCell:(ListOfDevicesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *element = self.dataSource[indexPath.row];
    UIImage *logo = [UIImage imageNamed:@"ic_list_dev"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.deviceHexagonImageView.image = logo;
    cell.titleModelDevaceLabel.text = [element valueForKey:@"manufacturer"];
    cell.descriptionModelDevaceLabel.text = [element valueForKey:@"bands"];

    if (indexPath.row % 2) {
        cell.marginContainerCellConstraint.constant = 16.f;
    } else {
        cell.marginContainerCellConstraint.constant = 45.f;
    }
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"listOfDevicesViewController.title");
    self.devicesNotDataLabel.text = dynamicLocalizedString(@"listOfDevicesViewController.devicesNotDataLabel");
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

@end
