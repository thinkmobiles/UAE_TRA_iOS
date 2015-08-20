//
//  ServiceInfoViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "ServiceInfoViewController.h"
#import "ServiceInfoCollectionViewCell.h"
#import "Animation.h"
#import "ServiceDetailedInfoViewController.h"

static NSUInteger const RowCount = 2;
static NSUInteger const ColumsCount = 5;

static NSString *const ServiceDetailsSegueIdentifier = @"serviceDetailsSegue";

@interface ServiceInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;

@property (strong, nonatomic) NSArray *dataSource;
@property (assign, nonatomic) BOOL isControllerPresented;

@end

@implementation ServiceInfoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.fakeBackground) {
        self.fakeBackgroundImageView.image = self.fakeBackground;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reverseDataSourceIfNeeded];
    [self animatAappearence];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:ServiceDetailsSegueIdentifier sender:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ServiceInfoCollectionViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ServiceInfoCollectionViewCell alloc] init];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat originY = self.collectionView.frame.origin.y;
    CGFloat collectionViewHeight = screenSize.height - originY;
    CGFloat collectionViewWidth = screenSize.width;
    CGFloat numbersOfRow = ColumsCount;
    CGFloat numbersOfColums = RowCount;
    CGFloat minimumSpacing = 10;
    CGFloat cellWidth = (collectionViewWidth - minimumSpacing * numbersOfColums) / numbersOfColums;
    CGFloat cellHeight = collectionViewHeight / numbersOfRow;
    
    if (self.dataSource.count % 2 && indexPath.row == self.dataSource.count - 1) {
        cellWidth = collectionViewWidth;
    }
    
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    return cellSize;
}

#pragma mark - IbActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.backgroundView.layer addAnimation:[Animation fadeAnimFromValue:1 to:0 delegate:self] forKey:@"hideView"];
    self.backgroundView.layer.opacity = 0.f;
}

#pragma mark - Animations

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.backgroundView.layer animationForKey:@"hideView"]) {
        [self.backgroundView.layer removeAllAnimations];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ServiceDetailsSegueIdentifier]) {
        CGSize size = CGSizeMake(self.navigationController.view.bounds.size.width, self.navigationController.view.bounds.size.height - 50);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSDictionary *dataSource = self.dataSource[((NSIndexPath *)[[self.collectionView indexPathsForSelectedItems] firstObject]).row];
        
        ServiceDetailedInfoViewController *serviceInfoController = segue.destinationViewController;
        serviceInfoController.fakeBackground = image;
        serviceInfoController.dataSource = dataSource;
    }
}

#pragma mark - Private

- (void)configureCell:(ServiceInfoCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedElement = self.dataSource[indexPath.row];
    cell.serviceInfoTitleLabel.text = dynamicLocalizedString([selectedElement valueForKey:@"serviceInfoItemName"]);
    cell.serviceInfologoImageView.image = [UIImage imageNamed:[selectedElement valueForKey:@"serviceInfoItemLogoName"]];
}

- (void)reverseDataSourceIfNeeded
{
    self.dataSource = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceInfoList" ofType:@"plist"]];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        self.dataSource = [self.dataSource reversedArrayByElementsInGroup:RowCount];
    }
}

- (void)animatAappearence
{
    if (!self.isControllerPresented) {
        [self.backgroundView.layer addAnimation:[Animation fadeAnimFromValue:0 to:1 delegate:nil] forKey:nil];
        self.isControllerPresented = YES;
    } else {
        [self.collectionView reloadData];
    }
}

@end
