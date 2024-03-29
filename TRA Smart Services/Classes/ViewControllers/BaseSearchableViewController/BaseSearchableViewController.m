//
//  BaseSearchableViewController.m
//  TRA Smart Services
//
//  Created by Admin on 17.08.15.
//

#import "BaseSearchableViewController.h"
#import "Animation.h"

@interface BaseSearchableViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchBarButtonItem;

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

#pragma mark - Public

- (BOOL)isSearchBarActive
{
    return [self.searchBar isFirstResponder];
}

#pragma mark - IBActions

- (IBAction)searchBarButtonTapped:(id)sender
{    
    [self.searchanbeleViewControllerTitle removeFromSuperview];
    
    CGRect navBarRect = self.navigationController.navigationBar.bounds;
    CGFloat offset = 20.f;
    self.searchBar.frame = CGRectMake(0, 0, navBarRect.size.width - offset * 3, navBarRect.size.height);
    self.searchBar.barTintColor = [UIColor whiteColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor darkGrayColor]];
    
    self.searchBar.layer.opacity = 1.f;
    CGRect titleRect = CGRectMake(0, 0, self.searchBar.bounds.size.width, self.titleView.bounds.size.height);
    self.titleView.bounds = titleRect;
    [self.titleView addSubview:self.searchBar];
    [self.searchBar.layer addAnimation:[Animation fadeAnimFromValue:0 to:1 delegate:nil] forKey:nil];
    [self.searchBar becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItems = @[];
    self.navigationItem.leftBarButtonItems = @[];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar.layer addAnimation:[Animation fadeAnimFromValue:1 to:0 delegate:self] forKey:@"hideSearchBar"];
    self.searchBar.layer.opacity = 0.f;
    [self.searchBar endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    UIView *view = searchBar.subviews[0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            cancelButton.titleLabel.minimumScaleFactor = 0.5f;
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelButton setTitle:dynamicLocalizedString(@"uiElement.cancelButton.title") forState:UIControlStateNormal];
        }
    }
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

#pragma mark - Animations

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.searchBar.layer animationForKey:@"hideSearchBar"]) {
        [self.searchBar.layer removeAllAnimations];
        [self.searchBar removeFromSuperview];
        [self.navigationItem setRightBarButtonItem:self.searchBarButtonItem animated:YES];
        CGRect titleRect = CGRectMake(self.navigationController.navigationBar.bounds.origin.x, self.navigationController.navigationBar.bounds.origin.y, self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height);
        self.titleView.frame = titleRect;
        [self.titleView addSubview: self.searchanbeleViewControllerTitle];
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
    
    CGRect titleRect = CGRectMake(self.navigationController.navigationBar.bounds.origin.x, self.navigationController.navigationBar.bounds.origin.y, self.navigationController.navigationBar.bounds.size.width / 2, self.navigationController.navigationBar.bounds.size.height);
    UIView *titleView = [[UIView alloc] initWithFrame:titleRect];
    self.titleView = titleView;
    self.navigationItem.titleView = self.titleView;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)prepareTitleLabel
{
    if (!self.searchanbeleViewControllerTitle) {
        self.searchanbeleViewControllerTitle = [[UILabel alloc] initWithFrame:self.titleView.bounds];
        self.searchanbeleViewControllerTitle.textColor = [UIColor whiteColor];
        self.searchanbeleViewControllerTitle.textAlignment = NSTextAlignmentCenter;
        self.searchanbeleViewControllerTitle.minimumScaleFactor = 0.8f;
        self.searchanbeleViewControllerTitle.numberOfLines = 0;
        self.searchanbeleViewControllerTitle.font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f];
    }
    [self.titleView addSubview: self.searchanbeleViewControllerTitle];
}

- (void)localizeUI
{
    self.searchanbeleViewControllerTitle.font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiBoldFontForSize:14.f] : [UIFont latoRegularWithSize:14.f];
}

- (void)updateColors
{
    //dummy
}

- (void)setRTLArabicUI
{
    //dummy
}

- (void)setLTREuropeUI
{
    //dummy
}

@end