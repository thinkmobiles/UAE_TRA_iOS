//
//  ViewController.m
//  testPentagonCells
//
//  Created by Kirill Gorbushko on 30.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuCollectionViewCell.h"
#import "CategoryCollectionViewCell.h"
#import "AppDelegate.h"

static CGFloat const CellSpacing = 5.f;
static CGFloat const RowCount = 4.f;
static CGFloat const CellSubmenuHeight = 140.f;
static CGFloat const ZigZagViewTag = 1001;
static CGFloat const TopViewHeightMultiplierValue = 0.18f;
static CGFloat const MaxScaleFactorForSpeedAccessCell = 0.9f;

static NSString *const HomeBarcodeReaderSegueIdentifier = @"HomeBarcodeReaderSegue";
static NSString *const HomeCheckDomainSegueIdentifier = @"HomeCheckDomainSegue";
static NSString *const HomePostFeedbackSegueIdentifier = @"HomePostFeedbackSegue";
static NSString *const HomeToHelpSalimSequeIdentifier = @"HomeToHelpSalimSeque";
static NSString *const HomeToCoverageSwgueIdentifier = @"HomeToCoverageSegue";
static NSString *const HomeSpeedTestSegueIdentifier = @"HomeSpeedTestSegue";
static NSString *const HomeToSpamReportSegueidentifier = @"HomeToSpamReportSegue";
static NSString *const HomeToCompliantSequeIdentifier = @"HomeToCompliantSeque";
static NSString *const HomeToSuggestionSequeIdentifier = @"HomeToSuggestionSeque";

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedAccessCollectionViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *speedAccessCollectionView;
@property (weak, nonatomic) IBOutlet HomeTopBarView *topView;

@property (strong, nonatomic) NSMutableArray *speedAccessDataSource;
@property (strong, nonatomic) NSMutableArray *otherServiceDataSource;

@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) BOOL isScrollintToTop;
@property (assign, nonatomic) BOOL stopAnimate;
@property (assign, nonatomic) BOOL isFirstTimeLoaded;

@end

@implementation HomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareTopBar];
    self.topView.enableFakeBarAnimations = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareZigZagView];
    [self.topView setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self prepareDataSource];
    
    if (self.isFirstTimeLoaded) {
        [self.speedAccessCollectionView reloadData];
        [self.menuCollectionView  reloadData];
    }
    self.isFirstTimeLoaded = YES;
    
    
    //    UIGraphicsBeginImageContext(self.topView.bounds.size);
    //    [self.topView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    //need to animate layer

    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.topView animateTopViewApearence];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.speedAccessDataSource removeAllObjects];
    //    [self.otherServiceDataSource removeAllObjects];
    //    [self.menuCollectionView  reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [self.speedAccessCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    [self.topView setStartApearenceAnimationParameters];

}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.speedAccessCollectionView) {
        [self speedAccessCollectionViewCellSelectedAtIndexPath:indexPath];
    } else {
        [self otherServiceCollectionViewCellSelectedAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger elementsCount = self.otherServiceDataSource.count;
    if (collectionView == self.speedAccessCollectionView) {
        elementsCount = self.speedAccessDataSource.count;
    }
    return elementsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (collectionView == self.menuCollectionView) {

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:MenuCollectionViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MenuCollectionViewCell alloc] init];
    }
    [self configureMainCell:(MenuCollectionViewCell *)cell atIndexPath:indexPath];
        
    } else if (collectionView == self.speedAccessCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCollectionViewCellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[CategoryCollectionViewCell alloc] init];
        }
        [self configureCategoryCell:(CategoryCollectionViewCell *)cell atIndexPath:indexPath];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = CellSubmenuHeight;
    CGSize contentSize = self.menuCollectionView.frame.size;

    if (collectionView == self.speedAccessCollectionView) {
        cellHeight = [UIScreen mainScreen].bounds.size.height * TopViewHeightMultiplierValue;
        contentSize = self.speedAccessCollectionView.frame.size;
    }
    
    CGSize cellSize = CGSizeMake((contentSize.width - (CellSpacing * (RowCount + 1))) / RowCount, cellHeight);
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGPoint center = cell.center;
    if (collectionView == self.speedAccessCollectionView) {
        [self animateSpeedAccessCell:cell atIndexPath:indexPath];
    } else {
        [self animateOtherCell:cell atIndexPath:indexPath];
    }
}

- (void)animationWithStartY:(NSInteger)startY stopY:(NSInteger)stopY duration:(CGFloat)duration andLayer:(CALayer *)layer
{
    CABasicAnimation *topToDownAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    topToDownAnimation.fromValue = @(startY);
    topToDownAnimation.toValue = @(stopY);
    topToDownAnimation.duration = duration;
    [layer addAnimation:topToDownAnimation forKey:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.menuCollectionView && !self.stopAnimate) {
        [self detectScrollDirectioninScrollView:scrollView];
        
        CGFloat minimumAllowedY = ([UIScreen mainScreen].bounds.size.height * TopViewHeightMultiplierValue) / 2;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat delta = self.lastContentOffset - contentOffsetY;
        
        if(contentOffsetY < minimumAllowedY && contentOffsetY >= 0 ) {
            if (ABS(self.speedAccessCollectionViewTopSpaceConstraint.constant + delta) > minimumAllowedY ||
                (self.speedAccessCollectionViewTopSpaceConstraint.constant + delta > 0)) {
                return;
            }
            self.speedAccessCollectionViewTopSpaceConstraint.constant += delta;
            [self.speedAccessCollectionView setContentOffset:CGPointZero animated:YES];
            [self.view layoutIfNeeded];
        }
        if (contentOffsetY > minimumAllowedY / 2 && self.isScrollintToTop) {
            [self.topView moveFakeButtonsToTop:YES];
        } else if (contentOffsetY < minimumAllowedY / 2 && !self.isScrollintToTop) {
            [self.topView moveFakeButtonsToTop:NO];
        }
        __weak typeof(self) weakSelf = self;
        CGFloat progress = -self.speedAccessCollectionViewTopSpaceConstraint.constant / minimumAllowedY;
        
        [self animateTopLogoWithProgress:progress];
        [self animateSpeedAcceesCollectionViewCellWithScaleFactor:progress];
        [self.topView updatedPositionForBottomWireForMovingProgress:progress];

        if (self.speedAccessCollectionViewTopSpaceConstraint.constant < - minimumAllowedY / 2) {
            [self.topView moveFakeButtonsToTop:YES];
            [weakSelf.topView updateOpacityForHexagons:progress];
        } else {
            [self.topView moveFakeButtonsToTop:NO];
            [weakSelf.topView updateOpacityForHexagons:0];
        }
    }
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (scrollView == self.menuCollectionView) {
        self.stopAnimate = YES;
        CGFloat minimumAllowedY = ([UIScreen mainScreen].bounds.size.height * TopViewHeightMultiplierValue) / 2;
        
        CGFloat constantValue = 0;
        if (self.isScrollintToTop) {
            constantValue = minimumAllowedY;
        }
        if (constantValue == ABS(self.speedAccessCollectionViewTopSpaceConstraint.constant)) {
            self.stopAnimate = NO;
        } else {
            if (!self.topView.isFakeButtonsOnTop && self.isScrollintToTop) {
                [self.topView moveFakeButtonsToTop:YES];
            } else if (self.topView.isFakeButtonsOnTop && !self.isScrollintToTop) {
                [self.topView moveFakeButtonsToTop:NO];
            }
            [self.view layoutIfNeeded];
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.speedAccessCollectionViewTopSpaceConstraint.constant = - constantValue;
                [weakSelf.topView updateOpacityForHexagons:constantValue ? 1 : 0];
                [weakSelf.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                weakSelf.stopAnimate = NO;
            }];
        }
        
        [self.topView scaleLogo:!self.isScrollintToTop];
        [self speedAcceesCollectionViewCellScale:!self.isScrollintToTop];
        if (self.topView.isBottomHexagonWireOnTop != self.isScrollintToTop) {
            [self.topView moveBottomHexagonWireToTop:self.isScrollintToTop];
        }
    }
}

#pragma mark - HomeTopBarViewDelegate

- (void)topBarInformationButtonDidPressedInView:(HomeTopBarView *)parentView
{
    NSLog(@"1");
}

- (void)topBarNotificationButtonDidPressedInView:(HomeTopBarView *)parentView
{
    NSLog(@"2");
}

- (void)topBarSearchButtonDidPressedInView:(HomeTopBarView *)parentView
{
    NSLog(@"3");
}

- (void)topBarLogoImageDidTouched:(HomeTopBarView *)parentView
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
    viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
#ifdef __IPHONE_8_0
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
#endif
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController presentViewController:viewController animated:NO completion:nil];
}

#pragma mark - Private

- (void)prepareDataSource
{
    self.speedAccessDataSource = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SpeedAccessServices" ofType:@"plist"]];
    self.otherServiceDataSource = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OtherServices" ofType:@"plist"]];
    
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        [self reverseDataSource];
    }
}

#pragma mark - Notifications

- (void)reverseDataSource
{
    self.speedAccessDataSource = [[self.speedAccessDataSource reversedArray] mutableCopy];
    NSMutableArray *reversedItems = [[NSMutableArray alloc] init];
    
    if (self.otherServiceDataSource.count < RowCount) {
        reversedItems = [[self.otherServiceDataSource reversedArray] mutableCopy];
    } else {
        int i;
        for (i = 0; i < (int)(self.otherServiceDataSource.count / RowCount); i++) {
            int j = RowCount - 1;
            while (j >= 0) {
                [reversedItems addObject:self.otherServiceDataSource[j + i * (int)RowCount]];
                j--;
            }
        }
        for (int k = (int)self.otherServiceDataSource.count - 1; k >= i* RowCount; k--) {
            [reversedItems addObject:self.otherServiceDataSource[k]];
        }
    }
    self.otherServiceDataSource = reversedItems;
}

- (void)transformTopView:(CATransform3D)transform
{
    self.topView.layer.transform = transform;
    self.topView.avatarView.layer.transform = transform;
}

- (void)setRTLArabicUI
{
    [self transformTopView:CATransform3DMakeScale(-1, 1, 1)];
}

- (void)setLTREuropeUI
{
    [self transformTopView:CATransform3DIdentity];
}

#pragma mark - Navigations

- (void)speedAccessCollectionViewCellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedServiceDetails = self.speedAccessDataSource[indexPath.row];
    switch ([[selectedServiceDetails valueForKey:@"serviceID"] integerValue]) {
        case 7: {
            [self performSegueWithIdentifier:HomeCheckDomainSegueIdentifier sender:self];
            break;
        }
        case 8: {
            [self performSegueWithIdentifier:HomeToCoverageSwgueIdentifier sender:self];
            break;
        }
        case 9: {
            [self performSegueWithIdentifier:HomeSpeedTestSegueIdentifier sender:self];
            break;
        }
        case 5: {
            [self performSegueWithIdentifier:HomeToSpamReportSegueidentifier sender:self];
            break;
        }
        default: {
            [AppHelper alertViewWithMessage:MessageNotImplemented];
            break;
        }
    }
}

- (void)otherServiceCollectionViewCellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedServiceDetails = self.otherServiceDataSource[indexPath.row];
    switch ([[selectedServiceDetails valueForKey:@"serviceID"] integerValue]) {
        case 2: {
            [self performSegueWithIdentifier:HomeBarcodeReaderSegueIdentifier sender:self];
            break;
        }
        case 4: {
            [self performSegueWithIdentifier:HomePostFeedbackSegueIdentifier sender:self];
            break;
        }
        case 6: {
            [self performSegueWithIdentifier:HomeToHelpSalimSequeIdentifier sender:self];
            break;
        }
        case 10: {
            [self performSegueWithIdentifier:HomeToCompliantSequeIdentifier sender:self];
            break;
        }
        case 11: {
            [self performSegueWithIdentifier:HomeToSuggestionSequeIdentifier sender:self];
            break;
        }
            
        default: {
            [AppHelper alertViewWithMessage:MessageNotImplemented];
            break;
        }
    }
}

#pragma mark - TopBar

- (void)prepareTopBar
{
    self.topView.delegate = self;
    self.topView.logoImage = [UIImage imageNamed:@"ic_user"];
    self.topView.userInitials = @"gK";
    self.topView.informationButtonImage = [UIImage imageNamed:@"ic_lamp"];
    self.topView.searchButtonImage = [UIImage imageNamed:@"ic_search"];
    self.topView.notificationButtonImage = [UIImage imageNamed:@"ic_not"];
}

#pragma mark - Localization

- (void)localizeUI
{
    
}

- (void)updateColors
{
    
}

- (void)configureMainCell:(MenuCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        cell.cellPresentationMode = PresentationModeModeBottom;
    } else {
        cell.cellPresentationMode = PresentationModeModeTop;
    }
    
    cell.polygonView.viewStrokeColor = [UIColor menuItemGrayColor];
    NSDictionary *selectedServiceDetails = self.otherServiceDataSource[indexPath.row];
    if ([selectedServiceDetails valueForKey:@"serviceLogo"]) {
        cell.itemLogoImageView.image = [UIImage imageNamed:[selectedServiceDetails valueForKey:@"serviceLogo"]];
    }
    cell.categoryID = [[selectedServiceDetails valueForKey:@"serviceID"] integerValue];
    cell.menuTitleLabel.text = dynamicLocalizedString([selectedServiceDetails valueForKey:@"serviceName"]);
    cell.menuTitleLabel.textColor = [UIColor menuItemGrayColor];
}

- (void)configureCategoryCell:(CategoryCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedServiceDetails = self.speedAccessDataSource[indexPath.row];
    
    if ([[selectedServiceDetails valueForKey:@"serviceNeedGradient"] boolValue]) {
        [cell.polygonView setGradientWithTopColors:@[(id)[UIColor itemGradientTopColor].CGColor, (id)[UIColor itemGradientBottomColor].CGColor]];
    } else {
        [cell.polygonView setGradientWithTopColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor]];
        [cell setTintColorForLabel:[UIColor defaultOrangeColor]];
    }
    
    if ([selectedServiceDetails valueForKey:@"serviceLogo"]) {
        cell.categoryLogoImageView.image = [UIImage imageNamed:[selectedServiceDetails valueForKey:@"serviceLogo"]];
    }
    cell.categoryTitleLabel.text = dynamicLocalizedString([selectedServiceDetails valueForKey:@"serviceName"]);
    cell.categoryID = [[selectedServiceDetails valueForKey:@"serviceID"] integerValue];
}

#pragma mark - Decorations

- (void)prepareZigZagView
{    
    UIView *zigZagView = [[UIView alloc] initWithFrame:self.speedAccessCollectionView.frame];
    zigZagView.backgroundColor = [UIColor clearColor];
    
    CGSize cellSize = CGSizeMake(( self.speedAccessCollectionView.frame.size.width - (CellSpacing * (RowCount + 1))) / RowCount, [UIScreen mainScreen].bounds.size.height * 0.18f);
    CGSize  hexagonSize = CGSizeMake(cellSize.width * 0.6f, cellSize.height * 0.87f);
    CGFloat minimumYPoint = hexagonSize.height * 0.9f;
    CGFloat maximumYPoint = hexagonSize.height + hexagonSize.height * 0.15f;
    
    UIBezierPath *zigZagPath = [UIBezierPath bezierPath];
    [zigZagPath moveToPoint:CGPointMake(0, minimumYPoint + CellSpacing)];
    [zigZagPath addLineToPoint:CGPointMake(CellSpacing, minimumYPoint)];
    
    CGFloat shadowOffset = 2;
    
    for (int i = 0; i < RowCount; i++) {
        [zigZagPath addLineToPoint:CGPointMake(((cellSize.width / 2 + CellSpacing - shadowOffset / 2) + (cellSize.width + CellSpacing ) * i), maximumYPoint)];
        if (i != RowCount - 1) {
            [zigZagPath addLineToPoint:CGPointMake((cellSize.width + CellSpacing ) * (i + 1) + shadowOffset,  minimumYPoint)];
        } else {
            [zigZagPath addLineToPoint:CGPointMake((cellSize.width + CellSpacing) * (i + 1),  minimumYPoint)];
        }
    }
    
    [zigZagPath addLineToPoint:CGPointMake(CGRectGetMaxX(zigZagView.frame), minimumYPoint + CellSpacing)];
    
    CAShapeLayer *zigZagLayer = [CAShapeLayer layer];
    zigZagLayer.path = zigZagPath.CGPath;
    zigZagLayer.strokeColor = [UIColor whiteColor].CGColor;
    zigZagLayer.fillColor = [UIColor clearColor].CGColor;
    [zigZagView.layer addSublayer:zigZagLayer];
    zigZagView.tag = ZigZagViewTag;
    
    self.speedAccessCollectionView.backgroundView = zigZagView;
}

#pragma mark - Animations vs Calculation for Animations

- (void)animateTopLogoWithProgress:(CGFloat)progress
{
    CGFloat scalePercent = progress == 1 ? progress : 1 - (1 - LogoScaleMinValue) * progress;
    
    if (scalePercent < 1 && scalePercent) {
        [self.topView scaleLogoFor:scalePercent];
    }
}

- (void)animateSpeedAcceesCollectionViewCellWithScaleFactor:(CGFloat)scaleFactor
{
    CGFloat scalePercent = scaleFactor == 1 ? scaleFactor : 1 - (1 - MaxScaleFactorForSpeedAccessCell) * scaleFactor;
    
    if (scalePercent < 1 && scalePercent) {
        for (CategoryCollectionViewCell *cell in [self.speedAccessCollectionView visibleCells]) {
            CATransform3D transformation = CATransform3DIdentity;
            transformation = CATransform3DScale(transformation, scalePercent, scalePercent, 1);
            cell.layer.transform  = transformation;
        }
    }
}

- (void)speedAcceesCollectionViewCellScale:(BOOL)animate
{
    CategoryCollectionViewCell *cell = (CategoryCollectionViewCell *)[[self.speedAccessCollectionView visibleCells] firstObject];
    CATransform3D startTransform = cell.layer.transform;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transformation = CATransform3DIdentity;
    transformation = animate ? CATransform3DIdentity : CATransform3DScale(transformation, MaxScaleFactorForSpeedAccessCell, MaxScaleFactorForSpeedAccessCell, 1);
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:startTransform];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:transformation];
    scaleAnimation.duration = 0.25;
    
    for (CategoryCollectionViewCell *cell in [self.speedAccessCollectionView visibleCells]) {
        [cell.layer addAnimation:scaleAnimation forKey:nil];
        cell.layer.transform  = transformation;
    }
}

//- (void)scaleCells
//{
//    if (self.isScrollintToTop) {
//        [self speedAcceesCollectionViewCellScale:!self.isScrollintToTop];
//    } else {
//        [self speedAcceesCollectionViewCellScale:YES];
//    }
//}

//- (void)scaleLogo
//{
//    if (self.isScrollintToTop) {
//        [self.topView scaleLogo:!self.isScrollintToTop];
//    } else {
//        [self.topView scaleLogo:YES];
//    }
//}

- (void)detectScrollDirectioninScrollView:(UIScrollView *)scrollView
{
    if (self.lastContentOffset > scrollView.contentOffset.y) {
        self.isScrollintToTop = NO;
    } else if (self.lastContentOffset < scrollView.contentOffset.y) {
        self.isScrollintToTop = YES;
    }
}

- (void)animateSpeedAccessCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.values = @ [
                         [NSValue valueWithCGPoint:CGPointMake(cell.center.x, 0)],
                         [NSValue valueWithCGPoint:CGPointMake(cell.center.x, 0)],
                         [NSValue valueWithCGPoint:cell.center]
                         ];
    moveAnim.keyTimes = @[@(0), @(0.1 * indexPath.row), @(1)];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0);
    opacityAnim.toValue = @(1);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[moveAnim, opacityAnim];
    group.duration = 0.15 + 0.05 * indexPath.row;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [cell.layer addAnimation:group forKey:nil];
}

- (void)animateOtherCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0);
    opacityAnim.toValue = @(1);
    opacityAnim.duration = 0.15 + 0.05 * indexPath.row;
    [cell.layer addAnimation:opacityAnim forKey:nil];
}

@end