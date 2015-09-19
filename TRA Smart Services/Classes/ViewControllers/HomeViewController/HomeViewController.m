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
#import "CompliantViewController.h"
#import "LoginViewController.h"
#import "NotificationViewController.h"
#import "UserProfileViewController.h"
#import "HomeSearchViewController.h"
#import "KeychainStorage.h"

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
static NSString *const HomeToSearchBrandNameSegueIdentifier = @"HomeToSearchBrandNameSegue";
static NSString *const HomeToNotificationSegueIdentifier = @"HomeToNotificationSegue";
static NSString *const HomeToUserProfileSegueIdentifier = @"UserProfileSegue";
static NSString *const HomeToHomeSearchSegueIdentifier = @"HomeToHomeSearchSegue";

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedAccessCollectionViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *speedAccessCollectionView;
@property (weak, nonatomic) IBOutlet HomeTopBarView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *movableImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) NSMutableArray *speedAccessDataSource;
@property (strong, nonatomic) NSMutableArray *otherServiceDataSource;

@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) BOOL isScrollintToTop;
@property (assign, nonatomic) BOOL stopAnimate;
@property (assign, nonatomic) BOOL isFirstTimeLoaded;
@property (assign, nonatomic) NSInteger selectedServiceIDHomeSearchViewController;

@end

@implementation HomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedServiceIDHomeSearchViewController = - 1;
    self.menuCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [self prepareTopBar];
    self.topView.enableFakeBarAnimations = YES;
    
    [AppHelper updateNavigationBarColor];
    [self disableInteractiveGesture];
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
    [self.speedAccessCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    [self.topView setStartApearenceAnimationParameters];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
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
    if (scrollView == self.menuCollectionView && !self.stopAnimate && !scrollView.decelerating) {
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
        CGFloat progress = -self.speedAccessCollectionViewTopSpaceConstraint.constant / minimumAllowedY;
        [self animateTopLogoWithProgress:progress];
        [self animateSpeedAcceesCollectionViewCellWithScaleFactor:progress];
        [self.topView animateBottomWireMovingWithProgress:progress];
        [self.topView animateFakeButtonsLayerMovingWithProgress:progress];
        [self.topView animateOpacityChangesForBottomLayers:progress];
        [self.scrollView setContentOffset:CGPointMake(0, - 0.01f * delta)];
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
            [self.view layoutIfNeeded];
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.speedAccessCollectionViewTopSpaceConstraint.constant = - constantValue;
                [weakSelf.topView animateOpacityChangesForBottomLayers:constantValue ? 1 : 0];
                [weakSelf.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                weakSelf.stopAnimate = NO;
            }];
        }
        [self.topView scaleLogo:!self.isScrollintToTop];
        [self speedAcceesCollectionViewCellScale:!self.isScrollintToTop];
        [self.topView animateBottomElementsMovingToTop:self.isScrollintToTop];
        [self.topView animateFakeButtonsLayerMovingToTop:self.isScrollintToTop];
    }
}

#pragma mark - HomeTopBarViewDelegate

- (void)topBarInformationButtonDidPressedInView:(HomeTopBarView *)parentView
{
    NSLog(@"1");
}

- (void)topBarNotificationButtonDidPressedInView:(HomeTopBarView *)parentView
{
    [self performSegueWithIdentifier:HomeToNotificationSegueIdentifier sender:self];
}

- (void)topBarSearchButtonDidPressedInView:(HomeTopBarView *)parentView
{
    [self performSegueWithIdentifier:HomeToHomeSearchSegueIdentifier sender:self];
}

- (void)topBarLogoImageDidTouched:(HomeTopBarView *)parentView
{
    [self.topView setStartApearenceAnimationParameters];

    __weak typeof(self) weakSelf = self;
    if ([NetworkManager sharedManager].isUserLoggined) {
        [self performSegueWithIdentifier:HomeToUserProfileSegueIdentifier sender:self];
    } else {
        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        navController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        LoginViewController *loginViewController = (LoginViewController *)navController.topViewController;
        loginViewController.shouldAutoCloseAfterLogin = YES;
        loginViewController.didDismissed = ^() {
            [weakSelf.topView animateTopViewApearence];
        };
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.navigationController presentViewController:navController animated:NO completion:nil];
    }
}

#pragma mark - Private

- (void)disableInteractiveGesture
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)prepareDataSource
{
    self.speedAccessDataSource = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SpeedAccessServices" ofType:@"plist"]];
    self.otherServiceDataSource = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OtherServices" ofType:@"plist"]];
        
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        [self reverseDataSource];
    }
}

- (UIImage *)setupFakeBackground
{
    CGSize size = CGSizeMake(self.navigationController.view.bounds.size.width, self.navigationController.view.bounds.size.height - 50);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)setupFullScreenFakeBackground
{
    CGSize size = CGSizeMake(self.navigationController.view.bounds.size.width, self.navigationController.view.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Notifications

- (void)reverseDataSource
{
    self.speedAccessDataSource = [[self.speedAccessDataSource reversedArray] mutableCopy];
    self.otherServiceDataSource = [self.otherServiceDataSource reversedArrayByElementsInGroup:RowCount];
}

- (void)transformTopView:(CATransform3D)transform
{
    self.topView.layer.transform = transform;
    self.topView.avatarView.layer.transform = transform;
}

#pragma mark - Navigations

- (void)speedAccessCollectionViewCellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    if (![NetworkManager sharedManager].networkStatus) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NoInternetConnection")];
        return;
    }
    
    NSDictionary *selectedServiceDetails = self.speedAccessDataSource[indexPath.row];
    [self sevriceSwitchPerformSegue:[[selectedServiceDetails valueForKey:@"serviceID"] integerValue]];
}

- (void)otherServiceCollectionViewCellSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    if (![NetworkManager sharedManager].networkStatus) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NoInternetConnection")];
        return;
    }
    NSDictionary *selectedServiceDetails = self.otherServiceDataSource[indexPath.row];
    [self sevriceSwitchPerformSegue:[[selectedServiceDetails valueForKey:@"serviceID"] integerValue]];
}

- (void)sevriceSwitchPerformSegue:(NSInteger) serviceID
{
    if (![NetworkManager sharedManager].networkStatus) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.NoInternetConnection")];
        return;
    }
    switch (serviceID) {
        case 2: {
            [self performSegueWithIdentifier:HomeBarcodeReaderSegueIdentifier sender:self];
            break;
        }
        case 3: {
            [self performSegueWithIdentifier:HomeToSearchBrandNameSegueIdentifier sender:self];
            break;
        }
        case 4: {
            [self performSegueWithIdentifier:HomePostFeedbackSegueIdentifier sender:self];
            break;
        }
        case 5: {
            [self performSegueWithIdentifier:HomeToSpamReportSegueidentifier sender:self];
            break;
        }
        case 6: {
            [self performSegueWithIdentifier:HomeToHelpSalimSequeIdentifier sender:self];
            break;
        }

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
        case 12:
        case 13:
        case 10: {
            [self performSegueWithIdentifier:HomeToCompliantSequeIdentifier sender:self];
            break;
        }
        case 11: {
            [self performSegueWithIdentifier:HomeToSuggestionSequeIdentifier sender:self];
            break;
        }
        default: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.notImplemented")];
            break;
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:HomeToCompliantSequeIdentifier]) {
        [self prepareCompliantViewControllerWithSegue:segue];
    } else if ([segue.identifier isEqualToString:HomeToNotificationSegueIdentifier]) {
        [self prepareNotificationViewControllerWithSegue:segue];
    } else if ([segue.identifier isEqualToString:HomeToHomeSearchSegueIdentifier]) {
        [self prepareHomeSearchViewControllerWithSegue:segue];
    }
}

- (void)prepareHomeSearchViewControllerWithSegue:(UIStoryboardSegue *)segue
{
    UIImage *img = [self setupFullScreenFakeBackground];
    HomeSearchViewController *homeSearchViewController = segue.destinationViewController;
    homeSearchViewController.fakeBackground = img;
    homeSearchViewController.hidesBottomBarWhenPushed = YES;

    __weak typeof(self) weakSelf = self;
    homeSearchViewController.didSelectService = ^(NSInteger selectedServiseID){
        weakSelf.navigationController.navigationBar.hidden = NO;
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        [UIView performWithoutAnimation:^{
            [weakSelf sevriceSwitchPerformSegue:selectedServiseID];
        }];
    };
}

- (void)prepareNotificationViewControllerWithSegue:(UIStoryboardSegue *)segue
{
    UIImage *img = [self setupFullScreenFakeBackground];
    NotificationViewController *notificationViewController = segue.destinationViewController;
    notificationViewController.fakeBackground = img;
    notificationViewController.hidesBottomBarWhenPushed = YES;
}

- (void)prepareCompliantViewControllerWithSegue:(UIStoryboardSegue *)segue
{
    CompliantViewController *viewController = segue.destinationViewController;
    NSIndexPath *indexPath = [[self.menuCollectionView indexPathsForSelectedItems] firstObject];
    NSDictionary *selectedServiceDetails = self.otherServiceDataSource[indexPath.row];
    NSUInteger serviceID = [[selectedServiceDetails valueForKey:@"serviceID"] integerValue];
    if (serviceID == 10) {
        viewController.type = ComplianTypeCustomProvider;
    } else if (serviceID == 12) {
        viewController.type = ComplianTypeEnquires;
    } else if (serviceID == 13) {
        viewController.type = ComplianTypeTRAService;
    }
}

#pragma mark - TopBar

- (void)prepareTopBar
{
    self.topView.delegate = self;
    self.topView.logoImage = [UIImage imageNamed:@"ic_user"];
    self.topView.informationButtonImage = [UIImage imageNamed:@"ic_lamp"];
    self.topView.searchButtonImage = [UIImage imageNamed:@"ic_search"];
    self.topView.notificationButtonImage = [UIImage imageNamed:@"ic_not"];
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    
}

- (void)updateColors
{
    UIImage *backgroundImage = [UIImage imageNamed:@"background"];
    UIImage *movableImage = [UIImage imageNamed:@"res_polygons"];

    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
        movableImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:movableImage];
    }
    
    self.movableImageView.image = movableImage;
    self.backgroundImageView.image = backgroundImage;
    
    [self.topView updateUIColor];
}

- (void)setRTLArabicUI
{
    [self transformTopView:CATransform3DMakeScale(-1, 1, 1)];
}

- (void)setLTREuropeUI
{
    [self transformTopView:CATransform3DIdentity];
}

#pragma mark - Configurations for Cells

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
        
        UIImage *serviceLogo = [UIImage imageNamed:[selectedServiceDetails valueForKey:@"serviceLogo"]];
        cell.itemLogoImageView.image = serviceLogo;
    }
    cell.categoryID = [[selectedServiceDetails valueForKey:@"serviceID"] integerValue];
    cell.menuTitleLabel.text = dynamicLocalizedString([selectedServiceDetails valueForKey:@"serviceName"]);
    cell.menuTitleLabel.textColor = [UIColor menuItemGrayColor];
    cell.menuTitleLabel.tag = DeclineTagForFontUpdate;
}

- (void)configureCategoryCell:(CategoryCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedServiceDetails = self.speedAccessDataSource[indexPath.row];
    
    NSArray *gradientColors = @[(id)[UIColor itemGradientTopColor].CGColor, (id)[UIColor itemGradientBottomColor].CGColor];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        gradientColors = @[(id)[UIColor blackColor].CGColor, (id)[[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor];
    }
    
    if ([[selectedServiceDetails valueForKey:@"serviceNeedGradient"] boolValue]) {
        [cell.polygonView setGradientWithTopColors:gradientColors];
    } else {
        [cell.polygonView setGradientWithTopColors:@[(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor]];
        [cell setTintColorForLabel:[[DynamicUIService service] currentApplicationColor]];
    }
    
    if ([selectedServiceDetails valueForKey:@"serviceLogo"]) {
        
        UIImage *serviceLogo = [UIImage imageNamed:[selectedServiceDetails valueForKey:@"serviceLogo"]];
        if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
            serviceLogo = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:serviceLogo];
        }

        cell.categoryLogoImageView.image = serviceLogo;
        cell.categoryLogoImageView.tintColor = [[DynamicUIService service] currentApplicationColor];
    }
    
    cell.categoryTitleLabel.text = dynamicLocalizedString([selectedServiceDetails valueForKey:@"serviceName"]);
    cell.categoryTitleLabel.tag = DeclineTagForFontUpdate;
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
        [self.topView animateLogoScaling:scalePercent];
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
    
    BOOL shouldBeScaled = self.speedAccessCollectionView.frame.origin.y < CGRectGetMaxY(self.topView.frame);
    
    CATransform3D transformation = CATransform3DIdentity;
    transformation = shouldBeScaled ? CATransform3DScale(transformation, MaxScaleFactorForSpeedAccessCell, MaxScaleFactorForSpeedAccessCell, 1) : CATransform3DIdentity;
    cell.layer.transform = transformation;
}

- (void)animateOtherCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0);
    opacityAnim.toValue = @(1);
    opacityAnim.duration = 0.15 + 0.05 * indexPath.row;
    [cell.layer addAnimation:opacityAnim forKey:nil];
    
    CGPoint center = cell.center;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self animationWithStartY:center.y - 5 stopY:center.y duration:0.2 andLayer:cell.layer];
    }];
    [self animationWithStartY:center.y + 50 stopY:center.y - 5 duration:0.2 andLayer:cell.layer];
    [CATransaction commit];
}

@end