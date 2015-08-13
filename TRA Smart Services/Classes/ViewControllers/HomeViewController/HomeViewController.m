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

static CGFloat const CellSpacing = 5.f;
static CGFloat const RowCount = 4.f;
static CGFloat const CellSubmenuHeight = 140.f;
static CGFloat const ZigZagViewTag = 1001;

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintVerticalMailCategoes;

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCategoryCollectionView;
@property (weak, nonatomic) IBOutlet HomeTopBarView *topView;

@property (assign, nonatomic) BOOL stopRedrawBackground;

@end

@implementation HomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareTopBar];
    self.topView.animationOn = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self prepareZigZagView];
    [self.topView setNeedsLayout];
    [self prepareBackgroundForMenuCollectionView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.stopRedrawBackground = YES;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    <#expression#>;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger elementsCount = 44;
    if (collectionView == self.mainCategoryCollectionView) {
        elementsCount = 4;
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
    if (scrollView == self.menuCollectionView) {
        CGFloat maxTopY = ([UIScreen mainScreen].bounds.size.height * 0.18f) * 0.5f;
        if ((self.constraintVerticalMailCategoes.constant < 0) && (self.constraintVerticalMailCategoes.constant > - maxTopY)) {
            self.topView.animationOn = YES;
            [self.topView moveFakeButtonsToTop:YES];
            [self.view layoutIfNeeded];
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.constraintVerticalMailCategoes.constant = - maxTopY;
                [weakSelf.topView drawWithGradientOpacityLevel:1];
                [weakSelf.view layoutIfNeeded];
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

#pragma mark - Private

#pragma mark - TopBar

- (void)prepareTopBar
{
    self.topView.delegate = self;
//    self.topView.logoImage = [UIImage imageNamed:@"1.jpg"];
    self.topView.userInitials = @"KK";
    self.topView.informationButtonImage = [UIImage imageNamed:@"1.jpg"];
    self.topView.searchButtonImage = [UIImage imageNamed:@"1.jpg"];
    self.topView.notificationButtonImage = [UIImage imageNamed:@"1.jpg"];
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
    
    cell.polygonView.viewStrokeColor = [UIColor grayColor];
}

- (void)configureCategoryCell:(CategoryCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell.polygonView setGradientWithTopColor:[UIColor grayColor] bottomColor:[UIColor lightGrayColor]];
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
    zigZagLayer.strokeColor = [UIColor redColor].CGColor;
    zigZagLayer.fillColor = [UIColor clearColor].CGColor;
    [zigZagView.layer addSublayer:zigZagLayer];
    zigZagView.tag = ZigZagViewTag;
    
    self.mainCategoryCollectionView.backgroundView = zigZagView;
}

- (void)prepareBackgroundForMenuCollectionView
{
    if (!self.stopRedrawBackground) {
        [self.menuCollectionView.backgroundView removeFromSuperview];
        
        HexagonicalImage *img = [[HexagonicalImage alloc] initWithRectColor:[UIColor greenColor]];
        UIImage *background = [img randomHexagonImageInRect:self.menuCollectionView.bounds];
        self.menuCollectionView.backgroundView = [[UIImageView alloc] initWithImage:background];
    }
}

@end