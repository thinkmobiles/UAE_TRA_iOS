//
//  AnnoucementsViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AnnoucementsViewController.h"
#import "AnnoucementsTableViewCell.h"
#import "DetailsViewController.h"


@interface AnnoucementsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static CGFloat const heightTableViewCell = 90.0f;
static NSString *const cellEuropeUIIdentifier = @"annoucementsCellEuropeUIIdentifier";
static NSString *const cellArabicUIIdentifier = @"annoucementsCellArabicUIIdentifier";
static NSString *const cellEuropeUINib =@"AnnoucementsTableViewCellEuropeUI";
static NSString *const cellArabicUINib =@"AnnoucementsTableViewCellArabicUI";
static NSString *const segueToDetailsViewControllerIdentifier =@"segueToDetailsViewController";


static CGFloat const deltaTableViewCell = 20.0f;
static CGFloat const indentTableViewCell = 24.0f;


@implementation AnnoucementsViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellEuropeUINib bundle:nil] forCellReuseIdentifier:cellEuropeUIIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:cellArabicUINib bundle:nil] forCellReuseIdentifier:cellArabicUIIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
    AnnoucementsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self cellUIIdentifier]];
    if (indexPath.row % 2) {
        cell.deltaConstraint.constant = indentTableViewCell + deltaTableViewCell;
    } else {
        cell.deltaConstraint.constant = indentTableViewCell;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.annocementsText.text = @"Text";
    cell.annocementsDate.text = [NSString stringWithFormat:@"date %li", (long)indexPath.row + 1];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self performSegueWithIdentifier:segueToDetailsViewControllerIdentifier sender:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text - %@", searchText);
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"annoucements.title");
}

- (void)updateColors
{
    
}

#pragma mark _ Private

- (NSString *)cellUIIdentifier
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return cellArabicUIIdentifier;
    }
    return cellEuropeUIIdentifier;
}

@end
