//
//  HomeSearchResultViewController.m
//  TRA Smart Services
//
//  Created by Admin on 15.09.15.
//


//temporary not used - waitnig response from client

#import "HomeSearchResultViewController.h"
#import "HomeSearchResultTableViewCell.h"
#import "TRAService.h"

static CGFloat HeightTableViewCell = 85.f;
static NSString *const HomeSearchResultCellIdentifier = @"homeSearchResultCell";

@interface HomeSearchResultViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;

@end

@implementation HomeSearchResultViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUI];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeSearchResultCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightTableViewCell;
}

#pragma mark - IBAction

- (IBAction)closeButtonTapped:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Private

- (void)prepareUI
{
    self.navigationController.navigationBar.hidden = NO;

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.closeBarButton.tintColor = [UIColor whiteColor];
}

- (void)setPrepareTitleLabel:(NSString *)title
{
    UILabel *titleView = [[UILabel alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = title;
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:14.f] : [UIFont latoRegularWithSize:14.f];
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

#pragma mark - Configurations

- (void)configureCell:(HomeSearchResultTableViewCell *)cell atIndexPath:(NSIndexPath *) indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *pairCellColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.1f];
    cell.backgroundColor = indexPath.row % 2 ? [UIColor clearColor] : pairCellColor;
    cell.serviceNameLabel.text = dynamicLocalizedString(((TRAService *)self.dataSource[indexPath.row]).serviceName);
    if (self.dynamicService.language == LanguageTypeArabic) {
        cell.serviceNameLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.serviceNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    cell.customAccessoryImageView.tintColor = [UIColor grayBorderTextFieldTextColor];
    cell.customAccessoryImageView.image = [UIImage imageNamed:@"right237"];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [self setPrepareTitleLabel:dynamicLocalizedString(@"homeSearchResultViewController.title")];
    [self.tableView reloadData];
}

- (void)updateColors
{

}

- (void)setRTLArabicUI
{

}

- (void)setLTREuropeUI
{

}

@end