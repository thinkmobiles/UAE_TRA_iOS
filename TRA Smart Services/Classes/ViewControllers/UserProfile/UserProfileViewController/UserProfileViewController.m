//
//  UserProfileViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 07.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserProfileTableViewCell.h"
#import "KeychainStorage.h"
#import "UIImage+DrawText.h"

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation UserProfileViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareDataSource];
    [self prepareUserView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[self.dynamicService currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserProfileTableViewCell *cell;
    if (self.dynamicService.language == LanguageTypeArabic) {
        cell = [tableView dequeueReusableCellWithIdentifier:UserProfileTableViewCellArabicCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:UserProfileTableViewCellEuropeanCellIdentifier forIndexPath:indexPath];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    NSString *segue = [dict valueForKey:@"seque"];
    if (segue.length) {
        [self performSegueWithIdentifier:segue sender:self];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.notImplemented")];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CAGradientLayer *headerGradient = [CAGradientLayer layer];
    headerGradient.frame = CGRectMake(0, 0, tableView.frame.size.width, 20.f);
    headerGradient.colors = @[(id)[UIColor whiteColor].CGColor, (id)[[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20.f)];
    [headerView.layer addSublayer:headerGradient];
    
    return headerView;
}

#pragma mark - Superclass methods

- (void)localizeUI
{
    [self.tableView reloadData];
    self.title = dynamicLocalizedString(@"userProfile.title");
}

- (void)updateColors
{
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;

    [AppHelper addHexagonBorderForLayer:self.userLogoImageView.layer color:[UIColor whiteColor] width:3.];
}

#pragma mark - Private

- (void)prepareDataSource
{
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserProfile" ofType:@"plist"]];
}

- (void)prepareUserView
{
    self.userNameLabel.text = [[KeychainStorage userName] capitalizedString];
    self.userLogoImageView.image = [UIImage imageNamed:@"test"];
    [AppHelper addHexagoneOnView:self.userLogoImageView];
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
}

- (void)configureCell:(UserProfileTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *element = self.dataSource[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:[element valueForKey:@"imageName"]];
    cell.titleLabel.text = dynamicLocalizedString([element valueForKey:@"name"]);
    if (indexPath.row == self.dataSource.count - 1) {
        cell.separatorView.hidden = YES;
        cell.shevronImageView.hidden = YES;
    }
}

@end
