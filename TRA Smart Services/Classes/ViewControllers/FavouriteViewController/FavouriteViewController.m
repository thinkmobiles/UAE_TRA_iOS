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

static CGFloat const AnimationDuration = 0.3f;
static CGFloat const DefaultOffsetForElementConstraintInCell = 20.f;
static CGFloat const SummOfVerticalOffsetsForCell = 85.f;

static NSString *const ServiceInfoListSegueIdentifier = @"serviceInfoListSegue";
static NSString *const AddToFavoriteSegueIdentifier = @"addToFavoriteSegue";

@interface FavouriteViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *placeHolderView;
@property (weak, nonatomic) IBOutlet UIButton *addFavouriteButton;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *actionDescriptionLabel;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *filteredDataSource;

@property (assign, nonatomic) BOOL removeProcessIsActive;

@property (strong, nonatomic) CALayer *arcDeleteZoneLayer;
@property (strong, nonatomic) CALayer *contentFakeIconLayer;
@property (strong, nonatomic) CALayer *shadowFakeIconLayer;

@end

@implementation FavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNibs];
    [self saveFavoriteListToDBIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self fetchFavouriteList];
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

- (NSManagedObjectModel *)managedObjectModel
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectModel;
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    [self showPlaceHolderIfNeeded];
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
    FavouriteTableViewCell *cell;
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:FavouriteArabicCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:FavouriteEuroCellIdentifier forIndexPath:indexPath];
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
    UIColor *pairCellColor = [[UIColor lightOrangeColor] colorWithAlphaComponent:0.8f];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        pairCellColor = [[[DynamicUIService service] currentApplicationColor] colorWithAlphaComponent:0.1f];
    }
    cell.backgroundColor = indexPath.row % 2 ? pairCellColor : [UIColor clearColor];
    cell.logoImage = [UIImage imageWithData:((TRAService *)self.dataSource[indexPath.row]).serviceIcon];
    cell.descriptionText = dynamicLocalizedString(((TRAService *)self.dataSource[indexPath.row]).serviceName);
    cell.delegate = self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF.serviceDescription contains %@", searchText];
        [self fetchFavouriteList];
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

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ServiceInfoListSegueIdentifier]) {
        ServiceInfoViewController *serviceInfoController = segue.destinationViewController;
        CGSize size = CGSizeMake(self.navigationController.view.bounds.size.width, self.navigationController.view.bounds.size.height - 50);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        serviceInfoController.fakeBackground = image;
    }
}

- (void)performNavigationToServiceWithIndex:(NSUInteger)navigationIndex
{
    UIViewController *selectedService;
    switch (navigationIndex) {
        case 2: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"checkIMEIID"];
            break;
        }
        case 3: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"mobileBrandID"];
            break;
        }
        case 4: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"feedbackID"];
            break;
        }
        case 5: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"spamReportID"];
            break;
        }
        case 6: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"helpSalimID"];
            break;
        }
        case 7: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"verificationID"];
            break;
        }
        case 8: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"coverageID"];
            break;
        }
        case 9: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"internetSpeedID"];
            break;
        }
        case 10: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"compliantID"];
            break;
        }
        case 11: {
            selectedService = [self.storyboard instantiateViewControllerWithIdentifier:@"suggestionID"];
            break;
        }
        default:
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.notImplemented")];
            break;
    }
    [self.navigationController pushViewController:selectedService animated:YES];
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
        self.placeHolderView.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.placeHolderView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

#pragma mark - CoreData

- (void)fetchFavouriteList
{
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"FavouriteService"];
    NSError *error;
    self.dataSource = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (error) {
        NSLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
}

- (void)saveFavoriteListToDBIfNeeded
{
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"AllService"];
    NSError *error;
    NSArray *data = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (error) {
        NSLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
    
    if (!data.count) {
        NSArray *speedAccessServices = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SpeedAccessServices" ofType:@"plist"]];
        NSMutableArray *otherServices = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OtherServices" ofType:@"plist" ]];
        [otherServices addObjectsFromArray:speedAccessServices];
        
        for (NSDictionary *dic in otherServices) {
            if (![[dic valueForKey:@"serviceName"] isEqualToString:@"speedAccess.service.name.-1"]) {
                NSEntityDescription *traServiceEntity = [NSEntityDescription entityForName:@"TRAService" inManagedObjectContext:self.managedObjectContext];
                TRAService *service = [[TRAService alloc] initWithEntity:traServiceEntity insertIntoManagedObjectContext:self.managedObjectContext];
                
                service.serviceIsFavorite = @(NO);
                service.serviceName = [dic valueForKey:@"serviceName"];
                
                service.serviceIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"btn_settings"], 1.0);//  UIImageJPEGRepresentation([UIImage imageNamed:[dic valueForKey:@"serviceLogo"]], 1.0);
                service.serviceDescription = @"No decription provided";
                service.serviceInternalID = @([[dic valueForKey:@"serviceID"] integerValue]);
            }
        }
    }
    
    [self.managedObjectContext save:nil];
}

#pragma mark - FavouriteTableViewCellDelegate

- (void)favouriteServiceInfoButtonDidPressedInCell:(FavouriteTableViewCell *)cell
{
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
            
            [self drawDeleteArea];
            
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
                    
                    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
                    
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

#pragma mark - Drawings

- (UIColor *)currentDeleteAreaColor
{
    UIColor *deleteAreaColor = [[UIColor redColor] colorWithAlphaComponent:0.8f];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        deleteAreaColor = [[[DynamicUIService service] currentApplicationColor] colorWithAlphaComponent:0.8f];
    }
    return deleteAreaColor;
}

- (void)drawDeleteArea
{
    [self prepareArcLayer];
    
    CGFloat heightOfScreen = [UIScreen mainScreen].bounds.size.height;
    CGFloat heightOfBottomDeletePart = heightOfScreen * 0.165;
    CGFloat startY = heightOfScreen - heightOfBottomDeletePart - ((UITabBarController *)[AppHelper rootViewController]).tabBar.frame.size.height;
    CGFloat arcHeight = 35.f;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat arcRadius = arcHeight / 2 + (width * width)/ (8 * arcHeight);
    
    UIBezierPath *arcBezierPath = [UIBezierPath bezierPath];
    [arcBezierPath moveToPoint:CGPointMake(0, startY)];
    [arcBezierPath addArcWithCenter:CGPointMake(width / 2, startY + arcRadius - heightOfBottomDeletePart) radius:arcRadius startAngle:0 endAngle:180 clockwise:YES];
    
    [self applyMaskToArcLayerWithPath:arcBezierPath];
    
    self.contentFakeIconLayer = [CALayer layer];
    CGFloat contentHeight = 50.f;
    CGFloat contentWidth = 44.f;
    self.contentFakeIconLayer.backgroundColor = [self currentDeleteAreaColor].CGColor;
    CGRect contentLayerRect = CGRectMake(width / 2 - contentWidth / 2, startY - heightOfBottomDeletePart / 2 , contentWidth, contentHeight);
    self.contentFakeIconLayer.frame = contentLayerRect;
    
    CGRect centerRect = CGRectMake(contentLayerRect.size.width * 0.25, contentLayerRect.size.height * 0.25, contentLayerRect.size.width * 0.5, contentLayerRect.size.height * 0.5);
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = centerRect;
    imageLayer.backgroundColor = [UIColor clearColor].CGColor;
    imageLayer.contents =(__bridge id __nullable)([UIImage imageNamed:@"ic_remove_red"]).CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    
    [self.contentFakeIconLayer addSublayer:imageLayer];
    
    CAShapeLayer *hexMaskLayer = [CAShapeLayer layer];
    hexMaskLayer.frame = self.contentFakeIconLayer.bounds;
    hexMaskLayer.path = [AppHelper hexagonPathForRect:self.contentFakeIconLayer.bounds].CGPath;
    self.contentFakeIconLayer.mask = hexMaskLayer;
    
    [self addShadowForContentLayerInRect:contentLayerRect];
    
    [self.arcDeleteZoneLayer addSublayer:self.contentFakeIconLayer];
    [self.arcDeleteZoneLayer insertSublayer:self.shadowFakeIconLayer below:self.contentFakeIconLayer];
    [self.tableView.layer addSublayer:self.arcDeleteZoneLayer];
    
    [self animateDeleteZoneAppearence];
}

- (void)prepareArcLayer
{
    self.arcDeleteZoneLayer = [CALayer layer];
    self.arcDeleteZoneLayer.frame = self.tableView.bounds;
    self.arcDeleteZoneLayer.backgroundColor = [[self currentDeleteAreaColor] colorWithAlphaComponent:0.3f].CGColor;
    self.arcDeleteZoneLayer.masksToBounds = YES;
}

- (void)applyMaskToArcLayerWithPath:(UIBezierPath *)arcBezierPath
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.arcDeleteZoneLayer.bounds;
    maskLayer.path = arcBezierPath.CGPath;
    maskLayer.shouldRasterize = YES;
    maskLayer.rasterizationScale = [UIScreen mainScreen].scale * 2.;
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.arcDeleteZoneLayer.mask = maskLayer;
}

- (void)addShadowForContentLayerInRect:(CGRect)contentLayerRect
{
    CGFloat shadowOffset = 5.f;
    CGRect shadowRect = CGRectMake(contentLayerRect.origin.x - shadowOffset, contentLayerRect.origin.y - shadowOffset, contentLayerRect.size.width + shadowOffset * 2, contentLayerRect.size.height + shadowOffset * 2);
    self.shadowFakeIconLayer = [CALayer layer];
    self.shadowFakeIconLayer.frame = shadowRect;
    [self.shadowFakeIconLayer setShadowPath:[AppHelper hexagonPathForRect:self.shadowFakeIconLayer.bounds].CGPath];
    [self.shadowFakeIconLayer setShadowOffset:CGSizeMake(0, 0)];
    [self.shadowFakeIconLayer setShadowRadius:5.f];
    [self.shadowFakeIconLayer setShadowOpacity:0.2f];
}

- (void)animateDeleteZoneAppearence
{
    CGPoint endPoint = self.arcDeleteZoneLayer.position;
    self.arcDeleteZoneLayer.position = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y + self.arcDeleteZoneLayer.bounds.size.height / 2);
    
    CABasicAnimation *positionAmimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAmimation.fromValue = [NSValue valueWithCGPoint:self.arcDeleteZoneLayer.position];
    positionAmimation.toValue = [NSValue valueWithCGPoint:endPoint];
    positionAmimation.duration = AnimationDuration / 2;
    
    CGPoint endPointForDeleteIcon = self.shadowFakeIconLayer.position;
    CGPoint startPoint = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y + self.arcDeleteZoneLayer.bounds.size.height);
    CGPoint midPoint = CGPointMake(endPointForDeleteIcon.x, endPointForDeleteIcon.y - 40); //40 offset
    
    self.shadowFakeIconLayer.position = startPoint;
    self.contentFakeIconLayer.position = startPoint;
    
    CAKeyframeAnimation * springAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    springAnim.values = @[
                          [NSValue valueWithCGPoint:startPoint],
                          [NSValue valueWithCGPoint:midPoint],
                          [NSValue valueWithCGPoint:endPointForDeleteIcon]
                          ];
    springAnim.duration = AnimationDuration;
    springAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.arcDeleteZoneLayer addAnimation:positionAmimation forKey:nil];
    [self.shadowFakeIconLayer addAnimation:springAnim forKey:nil];
    [self.contentFakeIconLayer addAnimation:springAnim forKey:nil];
    
    self.arcDeleteZoneLayer.position = endPoint;
    self.shadowFakeIconLayer.position = endPointForDeleteIcon;
    self.contentFakeIconLayer.position = endPointForDeleteIcon;
}

- (void)selectDeleteZone:(BOOL)select
{
    self.shadowFakeIconLayer.shadowOpacity = select ? 0.02f : 0.2f;
    self.contentFakeIconLayer.opacity = select ? 0.5 : 1.0;
    self.arcDeleteZoneLayer.backgroundColor = select ? [[self currentDeleteAreaColor] colorWithAlphaComponent:0.7f].CGColor : [[self currentDeleteAreaColor] colorWithAlphaComponent:0.3f].CGColor;
}

- (void)animateDeleteZoneDisapearing
{
    CGPoint startPoint = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y);
    CGPoint midPoint = CGPointMake(startPoint.x, startPoint.y + 10);
    CGPoint endPoint = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y + self.arcDeleteZoneLayer.frame.size.height / 2);
    
    CAKeyframeAnimation *disappearAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    disappearAnimation.values = @[
                          [NSValue valueWithCGPoint:startPoint],
                          [NSValue valueWithCGPoint:midPoint],
                          [NSValue valueWithCGPoint:endPoint]
                          ];
    disappearAnimation.duration = AnimationDuration / 2;
    disappearAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    disappearAnimation.delegate = self;
    disappearAnimation.removedOnCompletion = NO;
    [self.arcDeleteZoneLayer addAnimation:disappearAnimation forKey:@"disapearAnimation"];
    self.arcDeleteZoneLayer.opacity = 0.;
}

- (void)removeDeleteZone
{
    [self.arcDeleteZoneLayer removeFromSuperlayer];
}

#pragma mark - Animation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [super animationDidStop:anim finished:flag];
    
    if (anim == [self.arcDeleteZoneLayer animationForKey:@"disapearAnimation"]) {
        [self.arcDeleteZoneLayer removeAllAnimations];
        [self removeDeleteZone];
    }
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"favourite.title");
    self.informationLabel.text = dynamicLocalizedString(@"favourite.notification");
    self.actionDescriptionLabel.text = dynamicLocalizedString(@"favourite.button.addFav.title");
}

- (void)updateColors
{
    [self.addFavouriteButton setTintColor:[[DynamicUIService service] currentApplicationColor]];
    self.actionDescriptionLabel.textColor = [[DynamicUIService service] currentApplicationColor];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
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
