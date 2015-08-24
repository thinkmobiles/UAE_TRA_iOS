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
#import "RTLController.h"

@interface InfoHubViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *announcementsLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@property (strong, nonatomic) NSString *headerText;
@property (strong, nonatomic) NSArray *demoDataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;

@end

static CGFloat const SectionHeaderHeight = 80.0f;
static CGFloat const AdditionalCellOffset = 20.0f;
static CGFloat const DefaultCellOffset = 24.0f;

@implementation InfoHubViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
    [self prepareDemoDataSource];
    
    RTLController *rtl = [[RTLController alloc] init];
    [rtl disableRTLForView:self.view];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", searchText];
        NSArray *arraySort = [self.demoDataSource filteredArrayUsingPredicate:predicate];
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:arraySort];
    } else {
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:self.demoDataSource];
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
    
    [self prepareDemoDataSource];
    [self.tableView reloadData];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InfoHubCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[self collectionViewCellUIIdentifier] forIndexPath:indexPath];
    cell.announcementPreviewDateLabel.text = @"06/28/15";
    cell.announcementPreviewIconImageView.image = [UIImage imageNamed:@"ic_type_apr"];
    cell.announcementPreviewDescriptionLabel.text = [NSString stringWithFormat:@"Regarding application process for frequncy spectrum %li", (long)indexPath.row + 1];
    return cell;
}

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
   
    cell.infoHubTransactionDescriptionLabel.text = @"Text Text Text";
    cell.infoHubTransactionTitleLabel.text = self.filteredDataSource[indexPath.row];
    cell.infoHubTransactionDateLabel.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(DefaultCellOffset, 30, self.view.bounds.size.width - DefaultCellOffset, 30);
    label.backgroundColor = [UIColor clearColor];
    label.text = self.headerText;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SectionHeaderHeight)];
    [view addSubview:label];
    return view;
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
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return InfoHubTableViewCellArabicIdentifier;
    }
    return InfoHubTableViewCellEuropeIdentifier;
}

- (NSString *)collectionViewCellUIIdentifier
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return InfoHubCollectionViewCellArabicIdentifier;
    }
    return InfoHubCollectionViewCellEuropeIdentifier;
}

- (void)prepareDemoDataSource
{
    self.demoDataSource = @[@"BMV",@"Mazda",@"Opel",@"Mercedes",@"Audi",@"Toyta",@"Porche"];
    self.filteredDataSource = [[NSMutableArray alloc] initWithArray:self.demoDataSource];
    
}

- (void)updateUI
{
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"infoHub.title");
    self.announcementsLabel.text = dynamicLocalizedString(@"announcements.label.text");
    self.headerText = dynamicLocalizedString(@"transactions.label.text");
    [self.seeMoreButton setTitle:dynamicLocalizedString(@"seeMore.button.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    
}

- (void)setRTLArabicUI
{
    [self updateUI];
}

- (void)setLTREuropeUI
{
    [self updateUI];
}

@end