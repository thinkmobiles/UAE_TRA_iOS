//
//  InfoHubViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InfoHubViewController.h"
#import "InfoHubCollectionViewCell.h"
#import "InfoHubTableViewCell.h"

@interface InfoHubViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *announcementsLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;
@property (weak, nonatomic) IBOutlet UIView *tableViewContentHolderView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceVerticalConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSeparatorSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSeparatorSpaceConstraint;

@property (strong, nonatomic) NSArray *collectionViewDataSource;
@property (strong, nonatomic) NSArray *tableViewDataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;

@end

static CGFloat const SectionHeaderHeight = 40.0f;
static CGFloat const AdditionalCellOffset = 20.0f;
static CGFloat const DefaultCellOffset = 22.0f;
static NSUInteger const VisibleAnnouncementPreviewElementsCount = 3;

@implementation InfoHubViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
    [self prepareDemoDataSource];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.45 animations:^{
        CGFloat currentOffsetForContentView = weakSelf.tableViewContentHolderView.frame.origin.y;
        CGFloat distanceToMoveView = currentOffsetForContentView - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        weakSelf.topSpaceVerticalConstraint.constant = - distanceToMoveView;
        [weakSelf.view layoutIfNeeded];
    }];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", searchText];
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
    [self prepareDemoDataSource];
    [self.tableView reloadData];
    
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.topSpaceVerticalConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    }];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return VisibleAnnouncementPreviewElementsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InfoHubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self collectionViewCellUIIdentifier] forIndexPath:indexPath];
    cell.announcementPreviewDateLabel.text = [AppHelper compactDateStringFrom:[NSDate date]];
    
    UIImage *logo = [UIImage imageNamed:@"ic_type_apr"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.previewLogoImage = logo;

    cell.announcementPreviewDescriptionLabel.text = [NSString stringWithFormat:@"Regarding application process for frequncy spectrum %li", (long)indexPath.row + 1];
    if (indexPath.row) {
        cell.announcementPreviewDescriptionLabel.text = @"Yout app ";
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
    InfoHubTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self tableViewCellUIIdentifier]];
    if (indexPath.row % 2) {
        cell.marginInfoHubContainerConstraint.constant = DefaultCellOffset + AdditionalCellOffset;
    } else {
        cell.marginInfoHubContainerConstraint.constant = DefaultCellOffset;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    cell.infoHubTransactionDescriptionLabel.text = @"Yout application for type Approval has been reviewd by TRA personel";
    cell.infoHubTransactionTitleLabel.text = self.filteredDataSource[indexPath.row];
    cell.infoHubTransactionTitleLabel.textColor = [self.dynamicService currentApplicationColor];
    cell.infoHubTransactionDateLabel.text = [AppHelper compactDateStringFrom:[NSDate date]];
    UIImage *logo = [UIImage imageNamed:@"ic_warn_red"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        logo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:logo];
    }
    cell.infoHubTransactionImageView.image = logo;
    cell.infoHubTransactionDescriptionLabel.tag = DeclineTagForFontUpdate;
    
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
    
    if (self.dynamicService.language == LanguageTypeArabic) {
        headerLabel.textAlignment = NSTextAlignmentRight;
    } else {
        headerLabel.textAlignment = NSTextAlignmentLeft;
    }

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
}

- (void)updateColors
{
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
}

- (void)setRTLArabicUI
{
    self.collectionViewDataSource = [self.collectionViewDataSource reversedArray];
    self.leftSeparatorSpaceConstraint.constant = 0;
    self.rightSeparatorSpaceConstraint.constant = DefaultCellOffset;
    [self updateUI];
    
    self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
}

- (void)setLTREuropeUI
{
    self.collectionViewDataSource = [self.collectionViewDataSource reversedArray];
    self.leftSeparatorSpaceConstraint.constant = DefaultCellOffset;
    self.rightSeparatorSpaceConstraint.constant = 0;
    [self updateUI];
    
    self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
}

#pragma mark - Private

- (void)registerNibs
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"InfoHubCollectionViewCellEuropeUI" bundle:nil] forCellWithReuseIdentifier:InfoHubCollectionViewCellEuropeIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"InfoHubCollectionViewCellArabicUI" bundle:nil] forCellWithReuseIdentifier:InfoHubCollectionViewCellArabicIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoHubTableViewCellEuropeUI" bundle:nil] forCellReuseIdentifier:InfoHubTableViewCellEuropeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoHubTableViewCellArabicUI" bundle:nil] forCellReuseIdentifier:InfoHubTableViewCellArabicIdentifier];
}

- (NSString *)tableViewCellUIIdentifier
{
    if (self.dynamicService.language == LanguageTypeArabic ) {
        return InfoHubTableViewCellArabicIdentifier;
    }
    return InfoHubTableViewCellEuropeIdentifier;
}

- (NSString *)collectionViewCellUIIdentifier
{
    if (self.dynamicService.language == LanguageTypeArabic ) {
        return InfoHubCollectionViewCellArabicIdentifier;
    }
    return InfoHubCollectionViewCellEuropeIdentifier;
}

- (void)prepareDemoDataSource
{
    self.tableViewDataSource = @[@"Type Approval", @"Frequesncy Spectrum Authorizaions", @".ea Domain news"];
    self.filteredDataSource = [[NSMutableArray alloc] initWithArray:self.tableViewDataSource];
}

- (void)updateUI
{
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

@end