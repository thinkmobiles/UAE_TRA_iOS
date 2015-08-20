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

@end

static NSString *const infoHubCollectionViewCellIdentifier = @"InfoHubCollectionViewCell";
static NSString *const infoHubTableViewCellIdentifier = @"InfoHubTableViewCell";
static CGFloat const heightTableViewCell = 90.0f;
static CGFloat const SectionHeaderHeight =80.0f;
static CGFloat const deltaTableViewCell = 20.0f;
static CGFloat const indentTableViewCell = 24.0f;

@implementation InfoHubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self backgroundClear];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
//    RTLController *rtl = [[RTLController alloc] init];
//    [rtl disableRTLForView:self.view];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text - %@", searchText);
}

#pragma mark - CollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InfoHubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:infoHubCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.dateLabel.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];
    cell.textLabel.text = [NSString stringWithFormat:@"Text numer %li", (long)indexPath.row + 1];
    
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        [cell.conteinerArabicUI setHidden:NO];
        [cell.conteinerEuropeUI setHidden:YES];
        NSLog(@"ArabicUI");
    } else {
        [cell.conteinerArabicUI setHidden:YES];
        [cell.conteinerEuropeUI setHidden:NO];
        NSLog(@"EuropeUI");
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.window.frame.size.width * 0.7f, 100.f);
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightTableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoHubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoHubTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.textInfoLabel.text = @"Text Text Text Text Text Text Text Text Text Text Text Text";
    cell.titleInfoLabel.text = @"Title";
    cell.dateInfoLabel.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];
    
    if (indexPath.row % 2) {
        cell.deltaConsrtraintArabicUI.constant = indentTableViewCell + deltaTableViewCell;
        cell.deltaConsrtraintEuropeUI.constant = indentTableViewCell + deltaTableViewCell;
    } else {
        cell.deltaConsrtraintArabicUI.constant = indentTableViewCell;
        cell.deltaConsrtraintEuropeUI.constant = indentTableViewCell;
    }
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        [cell.conteinerArabicUI setHidden:NO];
        [cell.conteinerEuropeUI setHidden:YES];
    } else {
        [cell.conteinerArabicUI setHidden:YES];
        [cell.conteinerEuropeUI setHidden:NO];
    }
    cell.backgroundColor = [UIColor clearColor];
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
