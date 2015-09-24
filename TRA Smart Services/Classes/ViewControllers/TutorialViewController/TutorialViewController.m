//
//
//  Created by Stas Volskyi on 10.11.14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "TutorialViewController.h"
#import "Animation.h"
#import "TutorialCollectionViewCell.h"

static NSUInteger const TutorialPageCount = 3;

static LanguageType startLanguage;

@interface TutorialViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *fakeColorShemeView;
@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;

@property (strong, nonatomic) NSMutableArray *tutorialImages;

@end

@implementation TutorialViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureDataSource];
    [self configurePageControl];
    self.tutorialPageControl.currentPage = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:0 to:1. delegate:nil] forKey:nil];
    self.view.layer.opacity = 1.f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self storeTutorialStatus];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:1. to:0. delegate:self] forKey:@"fadeAnimation"];
    self.view.layer.opacity = 0.f;
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
    cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    if (self.dynamicService.language == LanguageTypeArabic) {
        cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
    }
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

#pragma mark - Animation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.view.layer animationForKey:@"fadeAnimation"]) {
        if (self.didCloseViewController) {
            self.didCloseViewController();
        }
        [self.view.layer removeAllAnimations];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - SuperClassMethods

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"res_img_tut_fakeHome_1"];
    
    if (self.dynamicService.colorScheme != ApplicationColorBlackAndWhite) {
        NSString *backgrounfImageName = [NSString stringWithFormat:@"res_img_tut_fakeHome_%i", (int)self.dynamicService.colorScheme];
        self.backgroundImageView.image = [UIImage imageNamed:backgrounfImageName];
    }
    
    self.fakeColorShemeView.backgroundColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.8f];
}

- (void)localizeUI
{
    [self configureDataSource];
    [self.collectionView reloadData];
}

- (void)setRTLArabicUI
{
//    self.tutorialPageControl.layer.transform = TRANFORM_3D_SCALE;
    self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);

}

- (void)setLTREuropeUI
{
//    self.tutorialPageControl.layer.transform = CATransform3DIdentity;
    self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);

}

#pragma mark - Private

- (void)configureDataSource
{
    self.tutorialImages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < TutorialPageCount; i++) {
        NSString *fileName;
        if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
            fileName = [NSString stringWithFormat:@"TutorialScreen%i_1", (int)(i + 1)];
        } else {
            fileName = [NSString stringWithFormat:@"TutorialScreen%i_%i", (int)(i + 1), (int)self.dynamicService.colorScheme];
        }
        
        UIImage *tutorialScreen = [UIImage imageNamed:fileName];
        if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
            tutorialScreen = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:tutorialScreen];
        }
        [self.tutorialImages addObject:tutorialScreen];
    }
    
    if ([AppHelper isiOS9_0OrHigher]) {
        if (!startLanguage) {
            startLanguage = self.dynamicService.language;
        }
        if (startLanguage == LanguageTypeArabic) {
            self.tutorialImages = [[self.tutorialImages reversedArray] mutableCopy];
        }
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