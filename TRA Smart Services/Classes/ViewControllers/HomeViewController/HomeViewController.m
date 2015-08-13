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
#import "HexagonicalImage.h"
#import "AppDelegate.h"

static CGFloat const CellSpacing = 5.f;
static CGFloat const RowCount = 4.f;
static CGFloat const CellSubmenuHeight = 140.f;
static CGFloat const ZigZagViewTag = 1001;

static NSString *const HomeBarcodeReaderSegueIdentifier = @"HomeBarcodeReaderSegue";
static NSString *const HomeCheckDomainSegueIdentifier = @"HomeCheckDomainSegue";
static NSString *const HomePostFeedbackSegueIdentifier = @"HomePostFeedbackSegue";
static NSString *const HomeToHelpSalimSequeIdentifier = @"HomeToHelpSalimSeque";
static NSString *const HomeToCoverageSwgueIdentifier = @"HomeToCoverageSegue";

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVerticalMailCategoes;

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCategoryCollectionView;
@property (weak, nonatomic) IBOutlet HomeTopBarView *topView;

@property (assign, nonatomic) BOOL stopRedrawBackground;
@property (strong, nonatomic) NSMutableArray *speedAccessDataSource;
@property (strong, nonatomic) NSArray *otherServiceDataSource;

@property (assign, nonatomic) BOOL needsRealodCollectionsViews;
@property (assign, nonatomic) BOOL bottomAnimationsEnable;

@end

@implementation HomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareTopBar];
    [self prepareDataSource];
    self.topView.enableFakeBarAnimations = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareZigZagView];
    [self.topView setNeedsLayout];
    [self prepareBackgroundForMenuCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.stopRedrawBackground = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.needsRealodCollectionsViews) {
        [self.menuCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self.mainCategoryCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        self.needsRealodCollectionsViews = NO;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.mainCategoryCollectionView) {
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
            default: {
                [AppHelper alertViewWithMessage:MessageNotImplemented];
                break;
            }
        }
    } else {
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

            default: {
                [AppHelper alertViewWithMessage:MessageNotImplemented];
                break;
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger elementsCount = self.otherServiceDataSource.count;
    if (collectionView == self.mainCategoryCollectionView) {
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
        
    } else if (collectionView == self.mainCategoryCollectionView) {
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

    if (collectionView == self.mainCategoryCollectionView) {
        cellHeight = [UIScreen mainScreen].bounds.size.height * 0.18f;
        contentSize = self.mainCategoryCollectionView.frame.size;
    }
    
    CGSize cellSize = CGSizeMake((contentSize.width - (CellSpacing * (RowCount + 1))) / RowCount, cellHeight);
    return cellSize;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.menuCollectionView) {
        CGFloat maxTopY = ([UIScreen mainScreen].bounds.size.height * 0.18f) * 0.5f;
        __weak typeof(self) weakSelf = self;
        if ((scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y < maxTopY)) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.constraintVerticalMailCategoes.constant = - scrollView.contentOffset.y;
                [weakSelf.view layoutIfNeeded];
            }];
        } else if ((scrollView.contentOffset.y <= 0) && (self.constraintVerticalMailCategoes.constant != 0)){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.constraintVerticalMailCategoes.constant = 0;
                 [weakSelf.view layoutIfNeeded];
            }];
        } else if ((scrollView.contentOffset.y >= maxTopY) && (self.constraintVerticalMailCategoes.constant != -maxTopY)){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.constraintVerticalMailCategoes.constant = - maxTopY;
                [weakSelf.view layoutIfNeeded];
            }];
        }
        
        CGFloat gradientOpacityValue = -self.constraintVerticalMailCategoes.constant / maxTopY;
        if (self.constraintVerticalMailCategoes.constant < - maxTopY * 0.55f) {
            [self.topView moveFakeButtonsToTop:YES];
            [weakSelf.topView drawWithGradientOpacityLevel:gradientOpacityValue];
        } else {
            [self.topView moveFakeButtonsToTop:NO];
            [weakSelf.topView drawWithGradientOpacityLevel:0];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (scrollView == self.menuCollectionView && self.bottomAnimationsEnable) {
        self.bottomAnimationsEnable = NO;
        CGFloat maxTopY = ([UIScreen mainScreen].bounds.size.height * 0.18f) * 0.5f;
        if ((self.constraintVerticalMailCategoes.constant < 0) && (self.constraintVerticalMailCategoes.constant > - maxTopY)) {
            self.topView.enableFakeBarAnimations = YES;
            [self.topView moveFakeButtonsToTop:YES];
            [self.view layoutIfNeeded];
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.constraintVerticalMailCategoes.constant = - maxTopY;
                [weakSelf.topView drawWithGradientOpacityLevel:1];
            } completion:^(BOOL finished) {
                weakSelf.bottomAnimationsEnable = YES;
            }];
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

#pragma mark - Notifications

- (void)reverseDataSource
{
    self.needsRealodCollectionsViews = YES;
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
    [self reverseDataSource];
    [self transformTopView:CATransform3DMakeScale(-1, 1, 1)];
}

- (void)setLTREuropeUI
{
    [self reverseDataSource];
    [self transformTopView:CATransform3DIdentity];
}

#pragma mark - Private

- (void)prepareDataSource
{
    self.speedAccessDataSource = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SpeedAccessServices" ofType:@"plist"]];
    self.otherServiceDataSource = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OtherServices" ofType:@"plist"]];
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
    UIView *zigZagView = [[UIView alloc] initWithFrame:self.mainCategoryCollectionView.frame];
    zigZagView.backgroundColor = [UIColor clearColor];
    
    CGSize cellSize = CGSizeMake(( self.mainCategoryCollectionView.frame.size.width - (CellSpacing * (RowCount + 1))) / RowCount, [UIScreen mainScreen].bounds.size.height * 0.18f);
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
    
    self.mainCategoryCollectionView.backgroundView = zigZagView;
}

- (void)prepareBackgroundForMenuCollectionView
{
    if (!self.stopRedrawBackground) {
        [self.menuCollectionView.backgroundView removeFromSuperview];
        
        HexagonicalImage *img = [[HexagonicalImage alloc] initWithRectColor:[UIColor whiteColor]];
        UIImage *background = [img randomHexagonImageInRect:self.menuCollectionView.bounds];
        self.menuCollectionView.backgroundView = [[UIImageView alloc] initWithImage:background];
    }
}

@end