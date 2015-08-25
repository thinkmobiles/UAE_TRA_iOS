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

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *filteredDataSource;

@end

static NSString *const SegueToDetailsViewControllerIdentifier = @"segueToDetailsViewController";
static CGFloat const AdditionalCellOffset = 20.0f;
static CGFloat const DefaultCellOffset = 24.0f;

@implementation AnnoucementsViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnoucementsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self cellUIIdentifier]];
    if (indexPath.row % 2) {
        cell.marginAnnouncementContainerConstraint.constant = DefaultCellOffset + AdditionalCellOffset;
    } else {
        cell.marginAnnouncementContainerConstraint.constant = DefaultCellOffset;
    }    
    cell.annocementsDescriptionLabel.text = @"Regarding annoucement the start of a public consultations with all concerdned parties";
    cell.annoucementLogoImage = [UIImage imageNamed:@"test"];
    cell.annocementsDateLabel.text = @"08/03/15";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self performSegueWithIdentifier:SegueToDetailsViewControllerIdentifier sender:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", searchText];
        NSArray *arraySort = [self.dataSource filteredArrayUsingPredicate:predicate];
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:arraySort];
    } else {
        self.filteredDataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"annoucements.title");
}

- (void)updateColors
{
    
}

#pragma mark - Private

- (NSString *)cellUIIdentifier
{
    if ([DynamicUIService service].language == LanguageTypeArabic ) {
        return AnnoucementsTableViewCellArabicIdentifier;
    }
    return AnnoucementsTableViewCellEuropeIdentifier;
}

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnoucementsTableViewCellEuropeUI" bundle:nil] forCellReuseIdentifier:AnnoucementsTableViewCellEuropeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnoucementsTableViewCellArabicUI" bundle:nil] forCellReuseIdentifier:AnnoucementsTableViewCellArabicIdentifier];
}

@end