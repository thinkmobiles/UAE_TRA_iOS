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

@interface FavouriteViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *placeHolderView;
@property (weak, nonatomic) IBOutlet UIButton *addFavouriteButton;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

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
    [self fetchFavouriteList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self prepareAddFavouriteButton];
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

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    [self showPlaceHolderIfNeeded];
}

#pragma mark - IBActions

- (IBAction)addFavouriteButtonPress:(id)sender
{
    [self addDemoData];
    [self fetchFavouriteList];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
}

- (void)configureCell:(FavouriteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = indexPath.row % 2 ? [[UIColor lightOrangeColor] colorWithAlphaComponent:0.8f] : [UIColor clearColor];
    cell.logoImage = [UIImage imageWithData:((TRAService *)self.dataSource[indexPath.row]).serviceIcon];
    cell.descriptionText = ((TRAService *)self.dataSource[indexPath.row]).serviceDescription;
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TRAService"];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"serviceOrder" ascending:YES];
    [fetchRequest setSortDescriptors: @[descriptor]];
    NSError *error;
    self.dataSource = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (error) {
        NSLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
}

- (void)addDemoData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TRAService" inManagedObjectContext:self.managedObjectContext];
    
    int i = 0;
    TRAService *service = [[TRAService alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    if (arc4random() % 2) {
        service.serviceDescription = [NSString stringWithFormat:@"Addressing consumer disputes request with licensees on telecomunication services -  %i", (int)i];
        service.serviceIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"btn_chat"], 1.0);
    } else {
        service.serviceDescription = [NSString stringWithFormat:@"Broadband speed test -  %i", (int)i];
        service.serviceIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"btn_settings"], 1.0);
    }
    service.serviceName = [NSString stringWithFormat:@"Service name - %i", (int)i];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
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
                    
                    [self.managedObjectContext deleteObject:self.dataSource[sourceIndexPath.row]];
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

#pragma mark - UI

- (void)prepareAddFavouriteButton
{
    CGSize buttonSize = self.addFavouriteButton.frame.size;
    NSString *buttonTitle = dynamicLocalizedString(@"favourite.button.addFav.title");
    CGSize titleSize = [buttonTitle sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10.f] }];
    UIImage *buttonImage = self.addFavouriteButton.imageView.image;
    CGSize buttonImageSize = buttonImage.size;
    
    CGFloat offsetBetweenImageAndText = 10; //vertical space between image and text
    
    [self.addFavouriteButton setImageEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 - offsetBetweenImageAndText,
                                                (buttonSize.width - buttonImageSize.width) / 2,
                                                0,0)];
    self.addFavouriteButton.titleLabel.tag = 1001;
    [self.addFavouriteButton setTitleEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText,
                                                                 titleSize.width + [self.addFavouriteButton imageEdgeInsets].left > buttonSize.width ? -buttonImage.size.width  +  (buttonSize.width - titleSize.width) / 2 : (buttonSize.width - titleSize.width) / 2 - buttonImage.size.width,
                                                                 0,0)];
}

#pragma mark - Drawings

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
    self.contentFakeIconLayer.backgroundColor = [UIColor redColor].CGColor;
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
    self.arcDeleteZoneLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f].CGColor;
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
    self.arcDeleteZoneLayer.backgroundColor = select ? [[UIColor redColor] colorWithAlphaComponent:0.7f].CGColor : [[UIColor redColor] colorWithAlphaComponent:0.3f].CGColor;
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
    [self.addFavouriteButton setTitle: dynamicLocalizedString(@"favourite.button.addFav.title") forState:UIControlStateNormal];
    self.informationLabel.text = dynamicLocalizedString(@"favourite.notification");
}

- (void)updateColors
{
    [self.addFavouriteButton setTintColor:[[DynamicUIService service] currentApplicationColor]];
    [self.addFavouriteButton setTitleColor: [[DynamicUIService service] currentApplicationColor] forState:UIControlStateNormal];
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
