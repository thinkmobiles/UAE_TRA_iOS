//
//  FavouriteViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "FavouriteViewController.h"
#import "AppDelegate.h"
#import "TRAService.h"
#import "Animation.h"
#import "ServiceInfoViewController.h"
#import "CompliantViewController.h"
#import "FavouriteViewController+DeleteAction.h"

static CGFloat const DefaultOffsetForElementConstraintInCell = 20.f;
static CGFloat const SummOfVerticalOffsetsForCell = 85.f;


static NSString *const ServiceInfoListSegueIdentifier = @"serviceInfoListSegue";
static NSString *const AddToFavoriteSegueIdentifier = @"addToFavoriteSegue";

@interface FavouriteViewController ()

@property (weak, nonatomic) IBOutlet UIView *placeHolderView;
@property (weak, nonatomic) IBOutlet UIButton *addFavouriteButton;
@property (weak, nonatomic) IBOutlet UIButton *addServiceHiddenButton;
@property (weak, nonatomic) IBOutlet UIView *headerAddServiceView;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *actionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addServiceHiddenImageView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;

@property (assign, nonatomic) BOOL removeProcessIsActive;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation FavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
    self.headerAddServiceView.hidden = YES;
    
    [AppHelper addHexagoneOnView:self.addServiceHiddenImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self fetchFavouriteList];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.dataSource.count) {
        self.headerAddServiceView.hidden = NO;
    }
}

#pragma mark - Custom Accessors

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    [self showPlaceHolderIfNeeded];
}

- (CGFloat)headerHeight
{
    return self.headerAddServiceView.frame.size.height;
}

#pragma mark - IBActions

- (IBAction)addFavouriteButtonPress:(id)sender
{
    [self performSegueWithIdentifier:AddToFavoriteSegueIdentifier sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = self.dynamicService.language == LanguageTypeArabic ? FavouriteArabicCellIdentifier : FavouriteEuroCellIdentifier;
    FavouriteTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *serviceTitle = ((TRAService *)self.dataSource[indexPath.row]).serviceDescription;
    UIFont *font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:12.f] : [UIFont latoRegularWithSize:12.f];
    NSDictionary *attributes = @{ NSFontAttributeName :font };

    CGSize textSize = [serviceTitle sizeWithAttributes:attributes];
    CGFloat widthOfViewWithImage = 85.f;
    CGFloat labelWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - (widthOfViewWithImage + DefaultOffsetForElementConstraintInCell * 2);
    
    NSUInteger numbersOfLines = ceil(textSize.width / labelWidth);
    CGFloat height = numbersOfLines * textSize.height + SummOfVerticalOffsetsForCell;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TRAService *serviceToGo = self.dataSource[indexPath.row];
    NSUInteger navigationIndex = [serviceToGo.serviceInternalID integerValue];
    [self performNavigationToServiceWithIndex:navigationIndex];
}

- (void)configureCell:(FavouriteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *pairCellColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.1f];
    cell.backgroundColor = indexPath.row % 2 ? [UIColor clearColor] : pairCellColor;
    TRAService *traService = (TRAService *)self.dataSource[indexPath.row];

    cell.logoImage = [UIImage imageWithData:traService.serviceIcon];
    cell.descriptionText = dynamicLocalizedString(traService.serviceName);
    cell.delegate = self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TRAService *service, NSDictionary *bindings) {
            NSString *localizedServiceName = dynamicLocalizedString(service.serviceName);
            BOOL containsString = [[localizedServiceName uppercaseString] rangeOfString:[searchText uppercaseString]].location !=NSNotFound;
            return containsString;
        }];
        [self fetchFavouriteList];
        self.filteredDataSource = [[self.dataSource filteredArrayUsingPredicate:predicate] mutableCopy];
    
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

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ServiceInfoListSegueIdentifier]) {
        ServiceInfoViewController *serviceInfoController = segue.destinationViewController;
        serviceInfoController.hidesBottomBarWhenPushed = YES;
        serviceInfoController.selectedServiceID = [((TRAService *)self.dataSource[self.selectedIndexPath.row]).serviceInternalID integerValue];
        serviceInfoController.fakeBackground = [AppHelper snapshotForView:self.navigationController.view];
    }
}

- (void)performNavigationToServiceWithIndex:(NSUInteger)navigationIndex
{
    NSArray *serviceIdentifiers = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceViewControllersIdentifiers" ofType:@"plist"]];
    
    UIViewController *selectedService = [self.storyboard instantiateViewControllerWithIdentifier:serviceIdentifiers[navigationIndex]];
    if (navigationIndex == 10) {
        ((CompliantViewController *)selectedService).type = ComplianTypeCustomProvider;
    } else if (navigationIndex == 12) {
        ((CompliantViewController *)selectedService).type = ComplianTypeEnquires;
    } else if (navigationIndex == 13) {
        ((CompliantViewController *)selectedService).type = ComplianTypeTRAService;
    }

    if (selectedService) {
        [self.navigationController pushViewController:selectedService animated:YES];
    }
}

#pragma mark - Private

- (void)updateAndDisplayDataSource
{
    [self fetchFavouriteList];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"FavouriteEuroTableViewCell" bundle:nil] forCellReuseIdentifier:FavouriteEuroCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"FavouriteArabicTableViewCell" bundle:nil ] forCellReuseIdentifier:FavouriteArabicCellIdentifier];
}

#pragma mark - UICustomization

- (void)showPlaceHolderIfNeeded
{
    if (self.dataSource.count) {
        self.tableView.hidden = NO;
        self.headerAddServiceView.hidden = NO;
        self.headerAddServiceView.layer.opacity = 1.0f;
        
        self.placeHolderView.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        
        self.headerAddServiceView.layer.opacity = 0.0f;
        [self.headerAddServiceView.layer addAnimation:[Animation fadeAnimFromValue:1.f to:0.0f delegate:self] forKey:@"keyAnimationHidePlaceHolder"];
        self.placeHolderView.hidden = NO;
        self.placeHolderView.layer.opacity = 1.0f;
        [self.placeHolderView.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.f delegate:nil] forKey:nil];
    }
}

#pragma mark - CoreData

- (void)fetchFavouriteList
{
    self.dataSource = [[[CoreDataManager sharedManager] fetchFavouriteServiceList] mutableCopy];
}

#pragma mark - FavouriteTableViewCellDelegate

- (void)favouriteServiceInfoButtonDidPressedInCell:(FavouriteTableViewCell *)cell
{
    self.selectedIndexPath = [self.tableView indexPathForCell:cell];
    [self performSegueWithIdentifier:ServiceInfoListSegueIdentifier sender:self];
}

#pragma mark - GestureRecognizer on FavouriteTableViewCell

- (void)favouriteServiceDeleteButtonDidReceiveGestureRecognizerInCell:(FavouriteTableViewCell *)cell gesture:(UILongPressGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    FavouriteTableViewCell *selectedCell = cell;

    static UIView *snapshotView;
    static NSIndexPath *sourceIndexPath;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.removeProcessIsActive = YES;
            sourceIndexPath = indexPath;
            [selectedCell markRemoveButtonSelected:YES];
            
            snapshotView = [selectedCell snapshot];
            
            __block CGPoint center = selectedCell.center;
            snapshotView.center = center;
            snapshotView.alpha = 0.f;
            [self.tableView addSubview:snapshotView];
            
            [self drawDeleteAreaOnTable:self.tableView];
            
            [UIView animateWithDuration:0.25f animations:^{
                center.y = location.y;
                snapshotView.center = center;
                snapshotView.transform = CGAffineTransformMakeScale(0.95, 0.95);
                snapshotView.alpha = 0.98f;
                selectedCell.alpha = 0.0;
            } completion:^(BOOL finished) {
                selectedCell.hidden = YES;
            }];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.removeProcessIsActive) {
                CGPoint center = snapshotView.center;
                center.y = location.y;
                snapshotView.center = center;
                
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    if (![self isCellInRemoveAreaWithCenter:CGPointMake(0, CGRectGetMinY(snapshotView.frame))]) {
                        [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                        [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                        sourceIndexPath = indexPath;
                    }
                }
                if ([self isCellInRemoveAreaWithCenter:CGPointMake(0, center.y - self.tableView.contentOffset.y)]) {
                    [self selectDeleteZone:YES];
                } else {
                    [self selectDeleteZone:NO];
                }
            }
            break;
        }
        default: {
            if (self.removeProcessIsActive) {
                FavouriteTableViewCell *cell = (FavouriteTableViewCell *)[self.tableView cellForRowAtIndexPath:sourceIndexPath];
                cell.hidden = NO;
                cell.alpha = 0.0f;
                [cell markRemoveButtonSelected:NO];
                
                if ([self isCellInRemoveAreaWithCenter:snapshotView.center]) {
                    TRAService *serviceToRemoveFromFav = self.dataSource[sourceIndexPath.row];
                    serviceToRemoveFromFav.serviceIsFavorite = @(![serviceToRemoveFromFav.serviceIsFavorite boolValue]);
                    
                    [[CoreDataManager sharedManager] saveContext];
                    
                    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
                    [self showPlaceHolderIfNeeded];
                    [self.tableView deleteRowsAtIndexPaths:@[sourceIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [self.dataSource sortUsingComparator:^NSComparisonResult(TRAService *obj1, TRAService *obj2) {
                        return obj1.serviceOrder > obj2.serviceOrder;
                    }];
                }
                sourceIndexPath = nil;
                [snapshotView removeFromSuperview];
                snapshotView = nil;
                self.removeProcessIsActive = NO;
                [self animateDeleteZoneDisapearing];
                [self.tableView reloadData];
            }
            break;
        }
    }
}

- (BOOL)isCellInRemoveAreaWithCenter:(CGPoint)center
{
    BOOL isInRemoveArea = NO;
    
    CGFloat heightOFDeleteRect = [UIScreen mainScreen].bounds.size.height * 0.185f;
    CGFloat startY = self.tableView.bounds.size.height - heightOFDeleteRect;
    if (center.y > startY) {
        isInRemoveArea = YES;
    }
    return isInRemoveArea;
}

#pragma mark - Animation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [super animationDidStop:anim finished:flag];
    
    if (anim == [self.arcDeleteZoneLayer animationForKey:@"disapearAnimation"]) {
        [self.arcDeleteZoneLayer removeAllAnimations];
        [self removeDeleteZone];
    } else if (anim == [self.headerAddServiceView.layer animationForKey:@"keyAnimationHidePlaceHolder"] ) {
        self.headerAddServiceView.hidden = YES;
    } else if (anim == [self.placeHolderView.layer animationForKey:@"hidePlaceHolder"]) {
        self.placeHolderView.hidden = YES;
    }
}

- (void)performActionForUpdateUIWithTransform:(CATransform3D)transform
{
    self.addServiceHiddenButton.layer.transform = transform;
    self.headerAddServiceView.layer.transform = transform;
    
    [self fetchFavouriteList];
    [self.tableView reloadData];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    [super localizeUI];
    [self.addServiceHiddenButton setTitle:dynamicLocalizedString(@"favourite.button.addFav.title") forState:UIControlStateNormal];
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"favourite.title");
    self.informationLabel.text = dynamicLocalizedString(@"favourite.notification");
    self.actionDescriptionLabel.text = dynamicLocalizedString(@"favourite.button.addFav.title");
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"fav_back_orange"];
    
    [self.addFavouriteButton setTintColor:[self.dynamicService currentApplicationColor]];
    self.actionDescriptionLabel.textColor = [self.dynamicService currentApplicationColor];

    [self.addServiceHiddenButton setTitleColor:[self.dynamicService currentApplicationColor] forState:UIControlStateNormal];
    self.addServiceHiddenImageView.tintColor = [self.dynamicService currentApplicationColor];
    
    [AppHelper addHexagonBorderForLayer:self.addServiceHiddenImageView.layer color:[self.dynamicService currentApplicationColor] width:2.0f];
}

- (void)setRTLArabicUI
{
    [super setRTLArabicUI];
    
    [self.addServiceHiddenButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, -20.0)];
    [self performActionForUpdateUIWithTransform:TRANFORM_3D_SCALE];
}

- (void)setLTREuropeUI
{
    [super setLTREuropeUI];
    
    [self.addServiceHiddenButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -20.0, 0.0, 20.0)];
    [self performActionForUpdateUIWithTransform:CATransform3DIdentity];
}

@end
