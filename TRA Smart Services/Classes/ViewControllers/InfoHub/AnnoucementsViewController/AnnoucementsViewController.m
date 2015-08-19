//
//  AnnoucementsViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AnnoucementsViewController.h"
#import "AnnoucementsTableViewCell.h"

@interface AnnoucementsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static CGFloat const heightTableViewCell = 90.0f;
static NSString *const AnnoucementsTableViewCellIdentifier = @"AnnoucementsTableViewCell";
static NSString *const segueDetailsViewIdentifier = @"segueDetailsView";

@implementation AnnoucementsViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightTableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnoucementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AnnoucementsTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.textAnnocementsLabel.text = @"Text";
    cell.dateLabel.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];
    
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        [cell.conteinerArabicUI setHidden:NO];
        [cell.conteinerEuropeUI setHidden:YES];
    } else {
        [cell.conteinerArabicUI setHidden:YES];
        [cell.conteinerEuropeUI setHidden:NO];
    }
    if (indexPath.row % 2) {
        cell.deltaConstraint.constant = 44;
    } else {
        cell.deltaConstraint.constant = 24;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text - %@", searchText);
}

#pragma mark - IBActions

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: segueDetailsViewIdentifier]) {
        NSLog(@"segue to Details ViewController");
    }
}

#pragma mark - Private
#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"annoucements.title");
}

- (void)updateColors
{
    
}


@end
