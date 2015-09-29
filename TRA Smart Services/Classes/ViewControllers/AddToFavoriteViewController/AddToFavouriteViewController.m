//
//  FavouriteViewController.m
//  TRA Smart Services
//
//  Created by Admin on 14.08.15.
//

#import "AddToFavouriteViewController.h"
#import "AppDelegate.h"
#import "TRAService.h"
#import "Animation.h"

static CGFloat const DefaultOffsetForElementConstraintInCell = 20.f;
static CGFloat const SummOfVerticalOffsetsForCell = 60.f;

@interface AddToFavouriteViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;

@end

@implementation AddToFavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
    [self fetchServiceList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = self.dynamicService.language == LanguageTypeArabic ? AddToFavouriteArabicCellIdentifier : AddToFavouriteEuroCellIdentifier;
    AddToFavouriteTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self addRemoveFavoriteService:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *serviceTitle = ((TRAService *)self.dataSource[indexPath.row]).serviceDescription;
    UIFont *font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:12.f] : [UIFont latoRegularWithSize:12.f];
    NSDictionary *attributes = @{ NSFontAttributeName :font };

    CGSize textSize = [serviceTitle sizeWithAttributes:attributes];
    CGFloat widthOfViewWithImage = 85.f;
    CGFloat labelWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - (widthOfViewWithImage + DefaultOffsetForElementConstraintInCell * 2);
    
    NSUInteger numbersOfLines = ceil(textSize.width / labelWidth);
    CGFloat height = numbersOfLines * textSize.height + SummOfVerticalOffsetsForCell;
    
    return height;
}

- (void)configureCell:(AddToFavouriteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *pairCellColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.1f];
    cell.backgroundColor = indexPath.row % 2 ? pairCellColor : [UIColor clearColor];
    
    TRAService *traService = (TRAService *)self.dataSource[indexPath.row];
    cell.logoImage = [UIImage imageWithData:traService.serviceIcon];
    cell.descriptionText = dynamicLocalizedString(traService.serviceName);
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    BOOL isFavourite = [traService.serviceIsFavorite boolValue];
    [cell setServiceFavourite:isFavourite];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TRAService *service, NSDictionary *bindings) {
            NSString *localizedServiceName = dynamicLocalizedString(service.serviceName);
            BOOL containsString = [[localizedServiceName uppercaseString] rangeOfString:[searchText uppercaseString]].location != NSNotFound;
            return containsString;
        }];
        [self fetchServiceList];
        self.filteredDataSource = [[self.dataSource filteredArrayUsingPredicate:predicate] mutableCopy];
    
        self.dataSource = self.filteredDataSource;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self updateAndDisplayDataSource];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];

    [self updateAndDisplayDataSource];
}

#pragma mark - Private

- (void)updateAndDisplayDataSource
{
    [self fetchServiceList];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"AddToFavouriteEuroTableViewCell" bundle:nil] forCellReuseIdentifier:AddToFavouriteEuroCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddToFavouriteArabicTableViewCell" bundle:nil ] forCellReuseIdentifier:AddToFavouriteArabicCellIdentifier];
}

#pragma mark - CoreData

- (void)fetchServiceList
{
    self.dataSource = [[[CoreDataManager sharedManager] fetchServiceList] mutableCopy];
}

#pragma mark - FavouriteTableViewCellDelegate

- (void)addRemoveFavoriteService:(NSIndexPath *)indexPath
{
    TRAService *selectedService = self.dataSource[indexPath.row];
    selectedService.serviceIsFavorite = @(![selectedService.serviceIsFavorite boolValue]);
    
    [[CoreDataManager sharedManager] saveContext];

    AddToFavouriteTableViewCell *cell = (AddToFavouriteTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    BOOL isFavourite = [selectedService.serviceIsFavorite boolValue];
    [cell setServiceFavourite:isFavourite];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [super localizeUI];

    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"favourite.title");
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"fav_back_orange"];
}

- (void)setRTLArabicUI
{
    [super setRTLArabicUI];
    [self fetchServiceList];
    [self.tableView reloadData];
}

- (void)setLTREuropeUI
{
    [super setLTREuropeUI];
    [self fetchServiceList];
    [self.tableView reloadData];
}

@end
