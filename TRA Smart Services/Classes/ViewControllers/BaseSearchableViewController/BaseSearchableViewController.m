//
//  BaseSearchableViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseSearchableViewController.h"
#import "Animation.h"

@interface BaseSearchableViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchBarButtonItem;


@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIView *titleView;

@end

@implementation BaseSearchableViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareSearchBar];
    [self prepareNavigationBar];
    [self prepareTitleLabel];
}

#pragma mark - IBActions

- (IBAction)searchBarButtonTapped:(id)sender
{    
    [self.searchanbeleViewControllerTitle removeFromSuperview];
    
    CGRect navBarRect = self.navigationController.navigationBar.bounds;
    CGFloat offset = 20.f;
    self.searchBar.frame = CGRectMake(offset / 2, 0, navBarRect.size.width - offset, navBarRect.size.height);
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor defaultOrangeColor];
    
    self.searchBar.layer.opacity = 1.f;
    [self.titleView addSubview: self.searchBar];
    [self.searchBar.layer addAnimation:[Animation fadeAnimFromValue:0 to:1 delegate:nil] forKey:nil];
    [self.searchBar becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItems = @[];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar.layer addAnimation:[Animation fadeAnimFromValue:1 to:0 delegate:self] forKey:@"hideSearchBar"];
    self.searchBar.layer.opacity = 0.f;
    
    [self prepareTitleLabel];
}

#pragma mark - Animations

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.searchBar.layer animationForKey:@"hideSearchBar"]) {
        [self.searchBar.layer removeAllAnimations];
        [self.searchBar removeFromSuperview];
        [self.navigationItem setRightBarButtonItem:self.searchBarButtonItem animated:YES];
    }
}

#pragma mark - Private

- (void)prepareSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    [self.searchBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
}

- (void)prepareNavigationBar
{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIView *titleView = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    self.titleView = titleView;
    self.navigationItem.titleView = self.titleView;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)prepareTitleLabel
{
    if (!self.searchanbeleViewControllerTitle) {
        self.searchanbeleViewControllerTitle = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        self.searchanbeleViewControllerTitle.textColor = [UIColor whiteColor];
        self.searchanbeleViewControllerTitle.textAlignment = NSTextAlignmentCenter;
    }
    [self.titleView addSubview: self.searchanbeleViewControllerTitle];
}

@end
