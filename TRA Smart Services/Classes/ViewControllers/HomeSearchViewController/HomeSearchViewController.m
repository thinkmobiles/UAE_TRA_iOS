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

static NSString *const homeSearchCellIdentifier = @"homeSearchCell";
static CGFloat heightTableViewCell = 35.f;

@interface HomeSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *conteinerSearchView;
@property (weak, nonatomic) IBOutlet UITextField *homeSearchTextField;
@property (weak, nonatomic) IBOutlet UILabel *homeSearchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *conteinerView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

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
    [self saveFavoriteListToDBIfNeeded];
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
    [self closeButtonTapped:nil];
}

- (void)dealloc
{
    [self removeNotifications];
}

#pragma mark - Custom Accessors

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSManagedObjectModel *)managedObjectModel
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectModel;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeSearchCellIdentifier];
    
    cell.textLabel.text = dynamicLocalizedString(((TRAService *)self.filteredDataSource[indexPath.row]).serviceName);
    cell.textLabel.textColor = [UIColor whiteColor];
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.font = [UIFont droidKufiRegularFontForSize:14];
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont droidKufiRegularFontForSize:14];
    }
    if (self.homeSearchTextField.text.length) {
        [self highlightingSearchText:cell.textLabel];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    self.conteinerView.backgroundColor = [[[DynamicUIService service] currentApplicationColor] colorWithAlphaComponent:0.95];
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
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"FavouriteServiceAll"];
    NSError *error;
    self.dataSource = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (error) {
        NSLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
}

- (void)saveFavoriteListToDBIfNeeded
{
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"AllService"];
    NSError *error;
    NSArray *data = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (error) {
        NSLog(@"Cant fetch data from DB: %@\n%@",error.localizedDescription, error.userInfo);
    }
    
    if (!data.count) {
        NSArray *speedAccessServices = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SpeedAccessServices" ofType:@"plist"]];
        NSMutableArray *otherServices = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OtherServices" ofType:@"plist" ]];
        [otherServices addObjectsFromArray:speedAccessServices];
        
        for (NSDictionary *dic in otherServices) {
            if (![[dic valueForKey:@"serviceName"] isEqualToString:@"speedAccess.service.name.-1"]) { //temp while not all data avaliable
                NSEntityDescription *traServiceEntity = [NSEntityDescription entityForName:@"TRAService" inManagedObjectContext:self.managedObjectContext];
                TRAService *service = [[TRAService alloc] initWithEntity:traServiceEntity insertIntoManagedObjectContext:self.managedObjectContext];
                
                service.serviceIsFavorite = @(NO);
                service.serviceName = [dic valueForKey:@"serviceName"];
                if ([dic valueForKey:@"serviceDisplayLogo"]) {
                    service.serviceIcon = UIImageJPEGRepresentation([UIImage imageNamed:[dic valueForKey:@"serviceDisplayLogo"]], 1.0);
                }
                service.serviceDescription = @"No decription provided";
                service.serviceInternalID = @([[dic valueForKey:@"serviceID"] integerValue]);
            }
        }
    }
    [self.managedObjectContext save:nil];
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

@end
