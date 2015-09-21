//
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "TutorialViewController.h"
#import "Animation.h"
#import "TutorialCollectionViewCell.h"

@interface TutorialViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *verticalSeparator;

@property (strong, nonatomic) NSMutableArray *tutorialImages;

@end

@implementation TutorialViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureDataSource];
    [self configurePageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:0 to:1. delegate:nil] forKey:nil];
    self.view.layer.opacity = 1.f;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.collectionView.layoutMargins = UIEdgeInsetsZero;
    } else {
        self.collectionView.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark - IBAction

- (IBAction)skipButonTapped:(id)sender
{
    [self storeTutorialStatus];
    
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:1. to:0. delegate:self] forKey:@"fadeAnimation"];
    self.view.layer.opacity = 0.f;
}

- (IBAction)nextButtonTapped:(id)sender
{
        NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        self.tutorialPageControl.currentPage = indexPath.row + 1;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tutorialImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TutorialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TutorialCollectionViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[TutorialCollectionViewCell alloc] init];
    }
    cell.imageView.image = self.tutorialImages[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.bounds.size;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
        TutorialCollectionViewCell *cell = (TutorialCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (ABS(cell.frame.origin.x - self.collectionView.contentOffset.x) <= 50) {
            self.tutorialPageControl.currentPage = indexPath.row;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.collectionView.contentOffset.x >= CGRectGetWidth(self.collectionView.bounds) * (self.tutorialImages.count - 1.5) ) {
        self.nextButton.hidden = YES;
        self.verticalSeparator.hidden = YES;
    } else {
        self.nextButton.hidden = NO;
        self.verticalSeparator.hidden = NO;
    }
}

#pragma mark - Animation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.view.layer animationForKey:@"fadeAnimation"]) {
        [self.view.layer removeAllAnimations];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - SuperClassMethods

- (void)updateColors
{
    
}

- (void)localizeUI
{
    [self.skipButton setTitle:dynamicLocalizedString(@"tutorialViewController.skipButton.title") forState:UIControlStateNormal];
    [self.nextButton setTitle:dynamicLocalizedString(@"tutorialViewController.nextButton.title") forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)configureDataSource
{
    if (!self.tutorialImages) {
        self.tutorialImages = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < 4; i++) {
        NSString *fileName = [NSString stringWithFormat:@"TutorialScreen%i", (int)(i + 1)];
        UIImage *tutorialScreen = [UIImage imageNamed:fileName];
        if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
            tutorialScreen = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:tutorialScreen];
        }
        [self.tutorialImages addObject:tutorialScreen];
    }
}

- (void)configurePageControl
{
    self.tutorialPageControl.numberOfPages = self.tutorialImages.count;
}
- (void)storeTutorialStatus
{
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:KeyIsTutorialShowed];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end