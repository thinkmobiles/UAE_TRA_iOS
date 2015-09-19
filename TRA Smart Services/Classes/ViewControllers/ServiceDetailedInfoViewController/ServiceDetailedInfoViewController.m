//
//  ServiceDetailedInfoViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "ServiceDetailedInfoViewController.h"
#import "Animation.h"

@interface ServiceDetailedInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;

@end

@implementation ServiceDetailedInfoViewController

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
    
    [self.backgroundView.layer addAnimation:[Animation fadeAnimFromValue:0 to:1 delegate:nil] forKey:nil];
    self.navigationController.navigationBar.hidden = YES;

    [self configureViewController];
    [self configureDescriptionTextView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - IBActions

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

#pragma mark - Superclass

- (void)localizeUI
{

}

- (void)updateColors
{
    self.backgroundView.backgroundColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.9f];
}

#pragma mark - Private

- (void)configureViewController
{
    self.logoImageView.image = [UIImage imageNamed:[self.dataSource valueForKey:@"serviceInfoItemBigLogoName"]];
}

- (void)configureDescriptionTextView
{
    self.descriptionTextView.text = self.detailedInfoText.length ? self.detailedInfoText :dynamicLocalizedString([self.dataSource valueForKey:@"serviceInfoItmeDetailedDescription"]);

    self.descriptionTextView.textAlignment = self.dynamicService.language == LanguageTypeArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
}

@end
