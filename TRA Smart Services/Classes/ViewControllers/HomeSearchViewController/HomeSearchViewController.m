//
//  HomeSearchViewController.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 09.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "Animation.h"
#import "TRAService.h"
#import "AppDelegate.h"
#import "HomeSearchResultViewController.h"

static NSString *const HomeSearchCellIdentifier = @"homeSearchCell";
static CGFloat const HeightTableViewCell = 35.f;

@interface HomeSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *conteinerSearchView;
@property (weak, nonatomic) IBOutlet AligmentTextField *homeSearchTextField;
@property (weak, nonatomic) IBOutlet AligmentLabel *homeSearchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *conteinerView;

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *filteredDataSource;

@end

@implementation HomeSearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareNotification];
    [self prepareUI];
    [self prepareDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.conteinerView.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.homeSearchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)dealloc
{
    [self removeNotifications];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeSearchCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightTableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredDataSource.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectService) {
        TRAService *selectedService = self.filteredDataSource[indexPath.row];
        self.didSelectService([selectedService.serviceInternalID integerValue]);
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.homeSearchLabel.text = dynamicLocalizedString(@"homeSearchViewController.homeSearchLabel.text");
    self.homeSearchTextField.placeholder = dynamicLocalizedString(@"homeSearchViewController.homeSearchTextField.placeholder");
}

- (void)updateColors
{
    self.conteinerView.backgroundColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.95];
}

- (void)setRTLArabicUI
{
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 35, 0, 15)];
    
    self.conteinerSearchView.layer.transform = TRANFORM_3D_SCALE;
    self.homeSearchLabel.layer.transform = TRANFORM_3D_SCALE;
    self.homeSearchTextField.layer.transform = TRANFORM_3D_SCALE;
}

- (void)setLTREuropeUI
{
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 35)];
}

#pragma mark - KeyboardNotification

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeText:) name: UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChangeText:(id)sender
{
    if (self.homeSearchTextField.text.length) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(TRAService *service, NSDictionary *bindings) {
            NSString *localizedServiceName = dynamicLocalizedString(service.serviceName);
            BOOL containsString = [localizedServiceName rangeOfString:self.homeSearchTextField.text options:NSCaseInsensitiveSearch].location !=NSNotFound;
            return containsString;
        }];
        [self fetchFavouriteList];
        self.filteredDataSource = [[self.dataSource filteredArrayUsingPredicate:predicate] mutableCopy];
        
        self.dataSource = self.filteredDataSource;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        self.filteredDataSource = [[NSArray alloc] init];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - CoreData

- (void)fetchFavouriteList
{
    self.dataSource = [[CoreDataManager sharedManager] fetchServiceList];
}

#pragma mark - Private

- (void)prepareDataSource
{
    [self fetchFavouriteList];
    self.filteredDataSource = [[NSArray alloc] init];
}

- (void)prepareUI
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.homeSearchTextField setTintColor:[UIColor whiteColor]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (self.fakeBackground) {
        self.fakeBackgroundImageView.image = self.fakeBackground;
    }
}

- (void)highlightingSearchText:(UILabel *)label
{
    NSDictionary *attribs = @{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.5], NSFontAttributeName:label.font };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text attributes:attribs];
    NSRange searchTextRange = [label.text rangeOfString:self.homeSearchTextField.text options:NSCaseInsensitiveSearch];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:searchTextRange];
    label.attributedText = attributedText;
}

#pragma mark - Configurations

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = dynamicLocalizedString(((TRAService *)self.filteredDataSource[indexPath.row]).serviceName);
    cell.textLabel.textColor = [UIColor whiteColor];
    if (self.dynamicService.language == LanguageTypeArabic) {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.font = [UIFont droidKufiRegularFontForSize:14];
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont latoRegularWithSize:14];
    }
    if (self.homeSearchTextField.text.length) {
        [self highlightingSearchText:cell.textLabel];
    }
}

@end