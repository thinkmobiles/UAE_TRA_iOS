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
    NSDictionary *element = self.dataSource[indexPath.row];
    UIImage *logo = [UIImage imageNamed:[element valueForKey:@"iconDevice"]];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.deviceHexagonImageView.image = logo;
    cell.titleModelDevaceLabel.text = [element valueForKey:@"title"];
    cell.descriptionModelDevaceLabel.text = [element valueForKey:@"text"];

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
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

#pragma mark - Private

- (void)prepareDataSource
{
    NSDictionary *mobileDetails1 = @{ @"title" : @"HTC ChaCha",  @"text" : @"2G Network GSM 850 / 900 / 1800 / 1900 3G Network HSDPA 900 / 2100 SIM" , @"iconDevice" : @"ic_htc_salsa"};
    NSDictionary *mobileDetails2 = @{ @"title" : @"HTC Sasla",  @"text" : @"512 Memory / 5MP Rear Camera / 420x320 resolution / Dual Band Sim" , @"iconDevice" : @"ic_htc_salsa"};
    NSDictionary *mobileDetails3 = @{ @"title" : @"HTC Wildfire S",  @"text" : @"2G Network GSM 850 / 900 / 1800 / 1900 3G Network HSDPA 900 / 2100 SIM" , @"iconDevice" : @"ic_htc_salsa"};
    self.dataSource = @[mobileDetails1, mobileDetails2, mobileDetails3];
}

@end
