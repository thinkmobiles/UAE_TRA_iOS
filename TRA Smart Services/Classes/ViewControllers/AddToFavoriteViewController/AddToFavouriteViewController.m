//
//  FavouriteViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AddToFavouriteViewController.h"
#import "AppDelegate.h"
#import "TRAService.h"
#import "Animation.h"

static CGFloat const DefaultOffsetForElementConstraintInCell = 20.f;
static CGFloat const SummOfVerticalOffsetsForCell = 85.f;

@interface AddToFavouriteViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;

@end

@implementation AddToFavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
    [self fetchFavouriteList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self.tableView reloadData];
}

#pragma mark - Custom Accessors

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddToFavouriteTableViewCell *cell;
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:AddToFavouriteArabicCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:AddToFavouriteEuroCellIdentifier forIndexPath:indexPath];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *serviceTitle = ((TRAService *)self.dataSource[indexPath.row]).serviceDescription;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:12]};

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
    cell.backgroundColor = indexPath.row % 2 ? [[UIColor lightOrangeColor] colorWithAlphaComponent:0.8f] : [UIColor clearColor];
    cell.logoImage = [UIImage imageWithData:((TRAService *)self.dataSource[indexPath.row]).serviceIcon];
    cell.descriptionText = ((TRAService *)self.dataSource[indexPath.row]).serviceDescription;
    cell.indexPath = indexPath;
    cell.delegate = self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF.serviceDescription contains %@", searchText];
        self.filteredDataSource = [[self.dataSource filteredArrayUsingPredicate:filter] mutableCopy];
    
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
    [self fetchFavouriteList];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"AddToFavouriteEuroTableViewCell" bundle:nil] forCellReuseIdentifier:AddToFavouriteEuroCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddToFavouriteArabicTableViewCell" bundle:nil ] forCellReuseIdentifier:AddToFavouriteArabicCellIdentifier];
}

#pragma mark - CoreData

- (void)fetchFavouriteList
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TRAService"];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"serviceOrder" ascending:YES];
    [fetchRequest setSortDescriptors: @[descriptor]];
    NSError *error;
    self.dataSource = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (error) {
        NSLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
}

#pragma mark - FavouriteTableViewCellDelegate

- (void)addRemoveFavoriteService:(NSIndexPath *)indexPath
{
    NSLog(@"%li", (long)indexPath.row);
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"favourite.title");
}

- (void)setRTLArabicUI
{
    [super setRTLArabicUI];
    [self fetchFavouriteList];
    [self.tableView reloadData];
}

- (void)setLTREuropeUI
{
    [super setLTREuropeUI];
    [self fetchFavouriteList];
    [self.tableView reloadData];
}

@end
