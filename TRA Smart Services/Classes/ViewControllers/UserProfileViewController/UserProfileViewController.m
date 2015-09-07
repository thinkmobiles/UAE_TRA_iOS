//
//  UserProfileViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 07.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Animation.h"

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation UserProfileViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
    self.view.layer.opacity = 1.0f;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.didDismissed) {
        self.didDismissed();
    }
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    self.navigationController.navigationBar.hidden = YES;
    [self.view.layer addAnimation:[Animation fadeAnimFromValue:1.f to:0.0f delegate:self] forKey:@"dismissView"];
    self.view.layer.opacity = 0.0f;
}

#pragma mark - Animations

- (void)animationDidStop:(nonnull CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.view.layer animationForKey:@"dismissView"]) {
        [self.view.layer removeAllAnimations];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Superclass methods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"userProfile.title");
}

- (void)updateColors
{
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
}

#pragma mark - Private

- (void)prepareNavigationBar
{
    [self.navigationController.navigationBar setBackgroundColor:[[DynamicUIService service] currentApplicationColor]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName : [DynamicUIService service].language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f],
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                      }];
}

@end
