//
//  InfoHubViewController.m
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

#import "InfoHubViewController.h"
#import "InfoHubCollectionViewCell.h"
#import "InfoHubTableViewCell.h"
#import "TransactionModel.h"
#import "LoginViewController.h"

static CGFloat const SectionHeaderHeight = 40.0f;
static CGFloat const AdditionalCellOffset = 20.0f;
static CGFloat const DefaultCellOffset = 22.0f;
static NSUInteger const VisibleAnnouncementPreviewElementsCount = 3;

static LanguageType startingLanguageType;

@interface InfoHubViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *announcementsLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;
@property (weak, nonatomic) IBOutlet UIView *tableViewContentHolderView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceVerticalConstraint;
@property (weak, nonatomic) IBOutlet UILabel *transactionNotDataLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSeparatorSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSeparatorSpaceConstraint;

@property (strong, nonatomic) NSArray *collectionViewDataSource;
@property (strong, nonatomic) NSMutableArray *tableViewDataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;
@property (assign, nonatomic) __block NSInteger page;

@end

@implementation InfoHubViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.page = 1;
    [self presentLoginIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tableViewDataSource = nil;
    self.filteredDataSource = nil;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
#warning CUSTOM - commented out animations while not active announcements

//    [self.view layoutIfNeeded];
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:0.45 animations:^{
//        CGFloat currentOffsetForContentView = weakSelf.tableViewContentHolderView.frame.origin.y;
//        CGFloat distanceToMoveView = currentOffsetForContentView - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
//        weakSelf.topSpaceVerticalConstraint.constant = - distanceToMoveView;
//        [weakSelf.view layoutIfNeeded];
//    }];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains [c] %@", searchText];
        NSArray *arraySort = [self.tableViewDataSource filteredArrayUsingPredicate:predicate];
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:arraySort];
    } else {
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:self.tableViewDataSource];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
    
    searchBar.text = @"";
    self.filteredDataSource = self.tableViewDataSource;
    [self.tableView reloadData];
    
#warning CUSTOM - commented out animations while not active announcements
//    [self.view layoutIfNeeded];
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:0.25 animations:^{
//        weakSelf.topSpaceVerticalConstraint.constant = 0;
//        [weakSelf.view layoutIfNeeded];
//    }];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return VisibleAnnouncementPreviewElementsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.dynamicService.language == LanguageTypeArabic ? InfoHubCollectionViewCellArabicIdentifier : InfoHubCollectionViewCellEuropeIdentifier;
    InfoHubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.announcementPreviewDateLabel.text = [AppHelper compactDateStringFrom:[NSDate date]];
    
    UIImage *logo = [UIImage imageNamed:@"ic_type_apr"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.previewLogoImage = logo;
    cell.announcementPreviewDescriptionLabel.text = [NSString stringWithFormat:@"Regarding application process for frequncy spectrum %li", (long)indexPath.row + 1];
    if (indexPath.row) {
        cell.announcementPreviewDescriptionLabel.text = @"Your app ";
    }
    cell.announcementPreviewDescriptionLabel.tag = DeclineTagForFontUpdate;
    
    if (self.dynamicService.language == LanguageTypeArabic) {
        cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
    }

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width * 0.78f;
    CGFloat cellHeight = collectionView.bounds.size.height;
    
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    return cellSize;
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.dynamicService.language == LanguageTypeArabic ? InfoHubTableViewCellArabicIdentifier : InfoHubTableViewCellEuropeIdentifier;
    InfoHubTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.marginInfoHubContainerConstraint.constant = DefaultCellOffset;
    if (indexPath.row % 2) {
        cell.marginInfoHubContainerConstraint.constant += AdditionalCellOffset;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    TransactionModel *selectedTransactions = self.filteredDataSource[indexPath.row];
    
    cell.infoHubTransactionDescriptionLabel.text = selectedTransactions.transationDescription;
    cell.infoHubTransactionTitleLabel.text = selectedTransactions.title;
    cell.infoHubTransactionTitleLabel.textColor = [self.dynamicService currentApplicationColor];
    
    cell.infoHubTransactionDateLabel.text = [[selectedTransactions.traSubmitDatetime componentsSeparatedByString:@" "] firstObject];
    
    UIImage *logo = [UIImage imageNamed:@"ic_type_apr"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.infoHubTransactionImageView.image = logo;
    cell.infoHubTransactionDescriptionLabel.tag = DeclineTagForFontUpdate;
    
    if (indexPath.row == self.filteredDataSource.count - 1 && ![self isSearchBarActive]) {
        [self addObjectsToDataSourceIfPossible];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(DefaultCellOffset, 0, tableView.frame.size.width - DefaultCellOffset * 2, SectionHeaderHeight)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = dynamicLocalizedString(@"transactions.label.text");
    headerLabel.font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:11.f] : [UIFont latoBoldWithSize:11.f];
    
    CAGradientLayer *headerGradient = [CAGradientLayer layer];
    headerGradient.frame = CGRectMake(0, 0, tableView.frame.size.width, SectionHeaderHeight);
    headerGradient.colors = @[(id)[UIColor whiteColor].CGColor, (id)[[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SectionHeaderHeight)];
    [headerView.layer addSublayer:headerGradient];
    [headerView addSubview:headerLabel];
    
    headerLabel.textAlignment = self.dynamicService.language == LanguageTypeArabic ? NSTextAlignmentRight :  NSTextAlignmentLeft;
    return headerView;
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [super localizeUI];
    
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"infoHub.title");
    self.announcementsLabel.text = dynamicLocalizedString(@"announcements.label.text");
    self.announcementsLabel.font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:11.f] : [UIFont latoBoldWithSize:11.f];
    [self.seeMoreButton setTitle:dynamicLocalizedString(@"seeMore.button.title") forState:UIControlStateNormal];
    self.transactionNotDataLabel.text = dynamicLocalizedString(@"infoHubViewController.transactionNotDataLabel");
}

- (void)updateColors
{
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    [super updateBackgroundImageNamed:@"fav_back_orange"];
}

- (void)setRTLArabicUI
{
    [self updateUIForLeftBasedInterface:NO];
}

- (void)setLTREuropeUI
{
    [self updateUIForLeftBasedInterface:YES];
}

#pragma mark - Private

- (void)registerNibs
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"InfoHubCollectionViewCellEuropeUI" bundle:nil] forCellWithReuseIdentifier:InfoHubCollectionViewCellEuropeIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"InfoHubCollectionViewCellArabicUI" bundle:nil] forCellWithReuseIdentifier:InfoHubCollectionViewCellArabicIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoHubTableViewCellEuropeUI" bundle:nil] forCellReuseIdentifier:InfoHubTableViewCellEuropeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoHubTableViewCellArabicUI" bundle:nil] forCellReuseIdentifier:InfoHubTableViewCellArabicIdentifier];
}

- (void)updateUIForLeftBasedInterface:(BOOL)leftBased
{
    if ([AppHelper isiOS9_0OrHigher]) {
        if (!startingLanguageType) {
            startingLanguageType = self.dynamicService.language;
        }
        if (startingLanguageType == LanguageTypeArabic) {
            [self reverseDataSource];
        }
    } else {
        [self reverseDataSource];
    }
    
    self.leftSeparatorSpaceConstraint.constant = leftBased ? DefaultCellOffset : 0;
    self.rightSeparatorSpaceConstraint.constant = leftBased ? 0 : DefaultCellOffset;
    self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftBased ? 1 : -1, 1);

    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (void)reverseDataSource
{
    self.collectionViewDataSource = [self.collectionViewDataSource reversedArray];
}

- (void)addObjectsToDataSourceIfPossible
{
    __weak typeof(self) weakSelf = self;
    void (^PrepareDataSource)(NSArray *) = ^(NSArray *inputArray) {
        if (weakSelf.tableViewDataSource) {
            NSMutableArray *indexPathToAdd = [[NSMutableArray alloc] init];
            for (int i = (int)weakSelf.tableViewDataSource.count - 1; i < (int)weakSelf.tableViewDataSource.count - 1 + inputArray.count; i++) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPathToAdd addObject:newIndexPath];
            }
            [weakSelf.tableView beginUpdates];            
            [weakSelf.tableViewDataSource addObjectsFromArray:inputArray];
            weakSelf.filteredDataSource = weakSelf.tableViewDataSource;
            [weakSelf.tableView insertRowsAtIndexPaths:indexPathToAdd withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView endUpdates];
        } else {
            weakSelf.tableViewDataSource = [inputArray mutableCopy];
            weakSelf.filteredDataSource = [inputArray mutableCopy];
            [weakSelf.tableView reloadData];
        }
    };
    
    [AppHelper showLoader];
    [[NetworkManager sharedManager] traSSNoCRMServiceGetGetTransactions:self.page count:10 orderAsc:1 responseBlock: ^(id response, NSError *error) {
        if (error) {
            [response isKindOfClass:[NSString class]] ? [AppHelper alertViewWithMessage:response] : [AppHelper alertViewWithMessage:error.localizedDescription];
        } else {
            if (((NSArray *)response).count) {
            weakSelf.page++;
            PrepareDataSource(response);
            }
        }
        [AppHelper hideLoader];
    }];
}

- (void)setFilteredDataSource:(NSMutableArray *)filteredDataSource
{
    _filteredDataSource = filteredDataSource;

    self.transactionNotDataLabel.hidden = _filteredDataSource.count;
}

- (void)presentLoginIfNeeded
{
    if ([NetworkManager sharedManager].isUserLoggined) {
        [self addObjectsToDataSourceIfPossible];
    } else {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        __weak typeof(self) weakSelf = self;
        ((LoginViewController *)viewController.topViewController).didCloseViewController = ^() {
            if (![NetworkManager sharedManager].isUserLoggined) {
                weakSelf.tabBarController.selectedIndex = 0;
            }
        };
        ((LoginViewController *)viewController.topViewController).didDismissed = ^() {
            if ([NetworkManager sharedManager].isUserLoggined) {
                [weakSelf addObjectsToDataSourceIfPossible];
            }
        };
        ((LoginViewController *)viewController.topViewController).shouldAutoCloseAfterLogin = YES;
        [AppHelper presentViewController:viewController onController:self.navigationController];
    }
}

@end