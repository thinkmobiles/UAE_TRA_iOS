//
//  HomeSearchViewController.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 09.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "Animation.h"

static NSString *const homeSearchCellIdentifier = @"homeSearchCell";
static CGFloat heightTableViewCell = 35.f;

@interface HomeSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *conteinerSearchView;
@property (weak, nonatomic) IBOutlet UITextField *homeSearchTextField;
@property (weak, nonatomic) IBOutlet UILabel *homeSearchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *conteinerView;

@property (strong, nonatomic) NSArray *developmentDataSource;
@property (strong, nonatomic) NSArray *filteredDataSource;

@end

@implementation HomeSearchViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareNotification];
    if (self.fakeBackground) {
        self.fakeBackgroundImageView.image = self.fakeBackground;
    }
    [self prepareDataSource];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.conteinerView.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self closeButtonTapped:nil];
}

- (void)dealloc
{
    [self removeNotifications];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeSearchCellIdentifier];
    
    cell.textLabel.text = self.filteredDataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.font = [UIFont droidKufiRegularFontForSize:14];
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont droidKufiRegularFontForSize:14];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightTableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredDataSource.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CAGradientLayer *headerGradient = [CAGradientLayer layer];
    headerGradient.frame = CGRectMake(0, 0, tableView.frame.size.width, 20.f);
    headerGradient.colors = @[(id)[[DynamicUIService service] currentApplicationColor].CGColor, (id)[[[DynamicUIService service] currentApplicationColor] colorWithAlphaComponent:0.2f].CGColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20.f)];
    [headerView.layer addSublayer:headerGradient];
    
    return headerView;
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
    self.conteinerView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)setRTLArabicUI
{
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 35, 0, 15)];
    self.homeSearchLabel.textAlignment = NSTextAlignmentRight;
    self.homeSearchTextField.textAlignment = NSTextAlignmentRight;
    
    self.conteinerSearchView.layer.transform = CATransform3DMakeScale(-1, 1, 1);
    self.homeSearchLabel.layer.transform = CATransform3DMakeScale(-1, 1, 1);
    self.homeSearchTextField.layer.transform = CATransform3DMakeScale(-1, 1, 1);
}

- (void)setLTREuropeUI
{
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 35)];
    self.homeSearchLabel.textAlignment = NSTextAlignmentLeft;
    self.homeSearchTextField.textAlignment = NSTextAlignmentLeft;
    
  //  self.conteinerSearchView.layer.transform = CATransform3DIdentity;
//    self.homeSearchLabel.layer.transform = CATransform3DIdentity;
//    self.homeSearchTextField.layer.transform = CATransform3DIdentity;
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
    if(self.homeSearchTextField.text.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", self.homeSearchTextField.text];
        self.filteredDataSource = [self.developmentDataSource filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredDataSource = [[NSArray alloc] initWithArray: self.developmentDataSource];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Private

- (void)prepareDataSource
{
    self.developmentDataSource = @[@"Bulgaria, Sofia", @"Croatia, Zagreb", @"France, Paris", @"Hungary, Budapest", @"Italy, Rome", @"Poland, Warsaw", @"Slovakia, Bratislava", @"Great Britain, London", @"Macedonia, Skopje", @"Switzerland, Bern"];
    self.filteredDataSource = [[NSArray alloc] initWithArray: self.developmentDataSource];
}

@end
