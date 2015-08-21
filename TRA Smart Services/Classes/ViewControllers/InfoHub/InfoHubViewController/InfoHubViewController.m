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
@property (strong, nonatomic) NSArray *textArray;
@property (strong, nonatomic) NSMutableArray *searchArray;

@end

static CGFloat const heightTableViewCell = 90.0f;
static CGFloat const SectionHeaderHeight =80.0f;
static CGFloat const deltaTableViewCell = 20.0f;
static CGFloat const indentTableViewCell = 24.0f;

static NSString *const tableViewCellEuropeUIIdentifier = @"InfoHubTableViewCellEuropeUI";
static NSString *const tableViewCellArabicUIIdentifier = @"InfoHubTableViewCellArabicUI";
static NSString *const tableViewCellEuropeUINib =@"InfoHubTableViewCellEuropeUI";
static NSString *const tableViewCellArabicUINib =@"InfoHubTableViewCellArabicUI";

static NSString *const collectionViewCellEuropeUIIdentifier = @"InfoHubCollectionViewCellEuropeUI";
static NSString *const collectionViewCellArabicUIIdentifier = @"InfoHubCollectionViewCellArabicUI";
static NSString *const collectionViewCellEuropeUINib =@"InfoHubCollectionViewCellEuropeUI";
static NSString *const collectionViewCellArabicUINib =@"InfoHubCollectionViewCellArabicUI";

@implementation InfoHubViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:collectionViewCellEuropeUINib bundle:nil] forCellWithReuseIdentifier:collectionViewCellEuropeUIIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:collectionViewCellArabicUINib bundle:nil] forCellWithReuseIdentifier:collectionViewCellArabicUIIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:tableViewCellEuropeUINib bundle:nil] forCellReuseIdentifier:tableViewCellEuropeUIIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:tableViewCellArabicUINib bundle:nil] forCellReuseIdentifier:tableViewCellArabicUIIdentifier];

    [self backgroundClear];
    
    [self sourceDatail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    RTLController *rtl = [[RTLController alloc] init];
    [rtl disableRTLForView:self.view];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(!searchText.length) {
        self.searchArray = [[NSMutableArray alloc] initWithArray:self.textArray];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", searchText];
        NSArray *arraySort = [self.textArray filteredArrayUsingPredicate:predicate];
        self.searchArray = [[NSMutableArray alloc] initWithArray:arraySort];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [self sourceDatail];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
    [self sourceDatail];
    [self.tableView reloadData];
}

#pragma mark - CollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InfoHubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self collectionViewCellUIIdentifier] forIndexPath:indexPath];

    cell.dateLabel.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];
    cell.textLabel.text = [NSString stringWithFormat:@"Text numer %li", (long)indexPath.row + 1];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.view.window.frame.size.width * 0.7f < 250.0f) {
        return CGSizeMake(250.0f, 100.0f);
    }
    return CGSizeMake(self.view.window.frame.size.width * 0.7f, 100.0f);
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightTableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoHubTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self tableViewCellUIIdentifier]];
    if (indexPath.row % 2) {
        cell.deltaConstraint.constant = indentTableViewCell + deltaTableViewCell;
    } else {
        cell.deltaConstraint.constant = indentTableViewCell;
    }
    cell.backgroundColor = [UIColor clearColor];
   
    cell.textInfoLabel.text = @"Text Text Text";
    cell.titleInfoLabel.text = self.searchArray[indexPath.row];
    cell.dateInfoLabel.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(indentTableViewCell, 30, self.view.bounds.size.width - indentTableViewCell, 30);
    label.backgroundColor = [UIColor clearColor];
    label.text = self.headerText;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, SectionHeaderHeight)];
    [view addSubview:label];
    return view;
}

#pragma mark - Private

- (void)backgroundClear
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableViewCellUIIdentifier
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return tableViewCellArabicUIIdentifier;
    }
    return tableViewCellEuropeUIIdentifier;
}

- (NSString *)collectionViewCellUIIdentifier
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return collectionViewCellArabicUIIdentifier;
    }
    return collectionViewCellEuropeUIIdentifier;
}

- (void) sourceDatail
{
    self.textArray = @[@"BMV",@"Mazda",@"Opel",@"Mercedes",@"Audi",@"Toyta",@"Porche"];
    self.searchArray = [[NSMutableArray alloc] initWithArray:self.textArray];
    
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


@end
