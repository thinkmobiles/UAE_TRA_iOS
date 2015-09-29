//
//  ListOfMobileBrandViewController.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

#import "ListOfMobileBrandViewController.h"
#import "ListOfDevicesViewController.h"

#import "ListOfMobileBrandTableViewCell.h"

static NSString *const ListDeviceSegue = @"listOfDevicesSegue";

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ListDeviceSegue]) {
        ListOfDevicesViewController *cont = segue.destinationViewController;
        cont.dataSource = sender;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    NSString *brandName = [self.dataSource[indexPath.row] objectForKey:@"name"];
    [[NetworkManager sharedManager] traSSNoCRMServicePerformSearchByMobileBrand:brandName requestResult:^(id response, NSError *error) {
        if (error) {
            [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
        } else {
            [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TRAAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [loader dismissTRALoader];
                [weakSelf performSegueWithIdentifier:ListDeviceSegue sender:response];
            });
        }
    }];
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
