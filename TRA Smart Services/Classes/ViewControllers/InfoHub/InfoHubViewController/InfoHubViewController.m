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

@end

static NSString *const infoHubCollectionViewCellIdentifier = @"InfoHubCollectionViewCell";
static NSString *const infoHubTableViewCellIdentifier = @"InfoHubTableViewCell";
static CGFloat const heightTableViewCell = 90.0f;

@implementation InfoHubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self backgroundClear];
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
//    cell.image.image =
   
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
    
    cell.textInfoLabel.text = @"Text";
    cell.titleInfoLabel.text = @"Title";
    cell.dateInfoLabel.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];
    
    if (indexPath.row % 2) {
        cell.deltaConsrtraint.constant = 44;
    } else {
        cell.deltaConsrtraint.constant = 24;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - IBActions

- (IBAction)addFavouriteButtonPress:(id)sender
{
    
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
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"favourite.title");
    self.announcementsLabel.text = @"ANNOUNCEMENTS";
    [self.seeMoreButton setTitle:@"See more" forState:UIControlStateNormal];
}

- (void)updateColors
{
    
}


@end
