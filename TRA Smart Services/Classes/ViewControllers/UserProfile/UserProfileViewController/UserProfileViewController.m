//
//  UserProfileViewController.m
//  TRA Smart Services
//
//  Created by Admin on 07.09.15.
//

#import "UserProfileViewController.h"
#import "UserProfileTableViewCell.h"
#import "KeychainStorage.h"
#import "UIImage+DrawText.h"
#import "SettingViewController.h"

@interface UserProfileViewController ()

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
    
    self.title = dynamicLocalizedString(@"userProfile.title");
    [self prepareDataSource];
    [self prepareUserView];
    [self getProfileFromServer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[self.dynamicService currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self fillUserProfile];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.dynamicService.language == LanguageTypeArabic ? UserProfileTableViewCellArabicCellIdentifier : UserProfileTableViewCellEuropeanCellIdentifier;
    UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
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
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"userProfile.notificationMesasge") delegate:self otherButtonTitles:dynamicLocalizedString(@"uiElement.cancelButton.title")];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        [self performLogout];
    }
}

#pragma mark - Superclass methods

- (void)localizeUI
{
    [self.tableView reloadData];
    self.title = dynamicLocalizedString(@"userProfile.title");
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"fav_back_orange"];
}

#pragma mark - Private

- (void)getProfileFromServer
{
    TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] traSSGetUserProfileResult:^(id response, NSError *error) {
        if (error) {
            [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
        } else {
            UserModel *user = [[UserModel alloc] initWithDictionary:response];;
            [[KeychainStorage new] saveCustomObject:user key:userModelKey];
            [weakSelf fillUserProfile];
            [loader dismissTRALoader];
        }
    }];
}

- (void)fillUserProfile
{
    UserModel *user = [[KeychainStorage new] loadCustomObjectWithKey:userModelKey];
    if (!user) {
        user = [UserModel new];
    }
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    self.userLogoImageView.image = [UIImage imageNamed:@"ic_user_login"];
}

- (void)prepareDataSource
{
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserProfile" ofType:@"plist"]];
}

- (void)prepareUserView
{
    [AppHelper addHexagoneOnView:self.userLogoImageView];
    [AppHelper addHexagonBorderForLayer:self.userLogoImageView.layer color:[UIColor whiteColor] width:3.0];
    self.userLogoImageView.tintColor = [UIColor whiteColor];
}

- (void)prepareNavigationBar
{
    [super prepareNavigationBar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
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

- (void)performLogout
{
    [AppHelper showLoader];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] traSSLogout:^(id response, NSError *error) {
        if (error) {
            [AppHelper alertViewWithMessage:response];
        } else {
            KeychainStorage *storage = [[KeychainStorage alloc] init];
            [storage removeStoredCredentials];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KeyUseTouchIDIdentification];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        [AppHelper hideLoader];
    }];
}

@end
