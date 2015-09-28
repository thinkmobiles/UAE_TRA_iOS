//
//  SpamListViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 23.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

static NSInteger const UnblockServiceNumber = 7726;

static NSString *const LeftSegmentImageEurope = @"res_segm_sms_europe";
static NSString *const RightSegmentImageEurope = @"res_segm_web_europe";
static NSString *const LeftSegmentImageArabic = @"res_segm_web_arabic";
static NSString *const RightSegmentImageArabic = @"res_segm_sms_arabic";
static NSString *const SpamWebSegueIdentifier = @"spamWebSegueIdentifier";

#import "SpamListViewController.h"
#import "SpamReportViewController.h"

@interface SpamListViewController ()

@property (weak, nonatomic) IBOutlet UIView *topButtonContainer;
@property (weak, nonatomic) IBOutlet UIButton *addToSpamButton;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIView *headerSegmentHolderView;

@property (weak, nonatomic) IBOutlet UIView *fakeSegmentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectModeSwitch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSArray *activeDataSource;

@property (strong, nonatomic) CAShapeLayer *strokeLayer;

@end

@implementation SpamListViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareDataSource];
    [AppHelper addHexagoneOnView:self.addImageView];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
    [self drawSegment];
}

#pragma mark - IBActions

- (IBAction)addToSpamButtonTapped:(id)sender
{
    if (self.shouldNavigateToSpamReport) {
        self.shouldNavigateToSpamReport();
    }
}

- (IBAction)selectModeSwitchTapped:(UISegmentedControl *)sender
{
    sender.selectedSegmentIndex = sender.selectedSegmentIndex ? 0 : 1;
    [self performSegueWithIdentifier:SpamWebSegueIdentifier sender:self];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpamReportViewController *spamReportViewController = segue.destinationViewController;
    spamReportViewController.selectSpamReport = SpamReportTypeWeb;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", searchText];
        NSArray *arraySort = [self.dataSource filteredArrayUsingPredicate:predicate];
        self.activeDataSource = [[NSMutableArray alloc] initWithArray:arraySort];
    } else {
        self.activeDataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
    
    searchBar.text = @"";
    self.activeDataSource = self.dataSource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activeDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = self.dynamicService.language == LanguageTypeArabic ? SpamListTableViewCellArabicIdentifier : SpamListTableViewCellEuropeIdentifier;
    SpamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)configureCell:(SpamListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        [cell applyOffsetViewMode];
    }
    
    cell.spamTitleLabel.text = @"Test title";
    cell.spamDescriptionLabel.text = @"Test description description description description";
    cell.logoImage = [UIImage imageNamed:@"ic_ml"];
    cell.delegate = self;
}

#pragma mark - SpamListTableViewCellDelegate

- (void)unblockButtonDidTappedInCell:(SpamListTableViewCell *)cell
{
    [self performUnblockAction];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultFailed: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.FailedToSendSMS")];
            break;
        }
        case MessageComposeResultSent: {
            [self sendUnblockRequestToServer];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Superclass Methods

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"fav_back_orange"];
    UIColor *color = [self.dynamicService currentApplicationColor];
    [AppHelper addHexagonBorderForLayer:self.addImageView.layer color:color width:1.0f];
    [self.addToSpamButton setTitleColor:color forState:UIControlStateNormal];
    [self prepareSegmentControl];

    [self.tableView reloadData];
}

- (void)localizeUI
{
    [super localizeUI];
    
    self.searchanbeleViewControllerTitle.text = dynamicLocalizedString(@"spamListViewController.title");
}

- (void)setRTLArabicUI
{
    [self updateUIElementsTransform:TRANFORM_3D_SCALE];
    [self.addToSpamButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, -20.0)];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsTransform:CATransform3DIdentity];
    [self.addToSpamButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -20.0, 0.0, 20.0)];
}

#pragma mark - Private

- (void)prepareDataSource
{
#warning temp solution
    self.dataSource = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7"];
    self.activeDataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
}

- (void)updateUIElementsTransform:(CATransform3D)transform
{
    self.addToSpamButton.layer.transform = transform;
    self.topButtonContainer.layer.transform = transform;
#warning temp while block websites
    self.selectModeSwitch.selectedSegmentIndex = self.dynamicService.language == LanguageTypeArabic ? 1 : 0;
    [self.tableView reloadData];
}

- (void)sendUnblockRequestToServer
{
    //todo
}

- (void)prepareSegmentControl
{
    BOOL isArabicUI = self.dynamicService.language == LanguageTypeArabic;
    UIImage *leftImage = [UIImage imageNamed:isArabicUI ? LeftSegmentImageArabic : LeftSegmentImageEurope];
    UIImage *rightImage = [UIImage imageNamed:isArabicUI ? RightSegmentImageArabic : RightSegmentImageEurope];
    
    [self.selectModeSwitch setImage:leftImage forSegmentAtIndex:0];
    [self.selectModeSwitch setImage:rightImage forSegmentAtIndex:1];
    
    UIColor *color = [self.dynamicService currentApplicationColor];
    self.addImageView.tintColor = color;
    self.selectModeSwitch.tintColor = self.dynamicService.colorScheme == ApplicationColorBlackAndWhite ? color : [UIColor itemGradientTopColor];
    self.strokeLayer.strokeColor = self.dynamicService.colorScheme == ApplicationColorBlackAndWhite ? color.CGColor : [UIColor itemGradientTopColor].CGColor;
}

#pragma mark - MFController Preparations

- (void)performUnblockAction
{
    if ([MFMessageComposeViewController canSendText]) {
        [AppHelper showLoader];
        [self appearenceForMFController];
        [self presentMFController];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.FailedToInitializeMFController")];
    }
}

- (void)appearenceForMFController
{
    [UINavigationBar appearance].barTintColor = self.dynamicService.currentApplicationColor;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{
                                                         NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:17] : [UIFont latoRegularWithSize:17]
                                                         };
}

- (void)presentMFController
{
    NSArray *recipents = @[[NSString stringWithFormat:@"%i", (int)UnblockServiceNumber]];
    NSString *message = [NSString stringWithFormat:@"u %@", @"<HERE ADD NUMBER TO UNBLOCK>"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.navigationBar.tintColor = [UIColor whiteColor];
    messageController.messageComposeDelegate = self;
    
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [AppHelper hideLoader];
    }];
}

#pragma mark - Drawings

- (void)drawSegment
{
    CAShapeLayer *leftLayer = [CAShapeLayer layer];
    leftLayer.frame = self.selectModeSwitch.bounds;
    
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(self.selectModeSwitch.bounds.size.height / 3, 0)];
    [borderPath addLineToPoint:CGPointMake(self.selectModeSwitch.bounds.size.width - self.selectModeSwitch.bounds.size.height / 3, 0)];
    [borderPath addLineToPoint:CGPointMake(self.selectModeSwitch.bounds.size.width, self.selectModeSwitch.bounds.size.height / 2)];
    [borderPath addLineToPoint:CGPointMake(self.selectModeSwitch.bounds.size.width - self.selectModeSwitch.bounds.size.height / 3, self.selectModeSwitch.bounds.size.height)];
    [borderPath addLineToPoint:CGPointMake(self.selectModeSwitch.bounds.size.height / 3, self.selectModeSwitch.bounds.size.height)];
    [borderPath addLineToPoint:CGPointMake(0, self.selectModeSwitch.bounds.size.height / 2)];
    [borderPath addLineToPoint:CGPointMake(self.selectModeSwitch.bounds.size.height / 3, 0)];
    leftLayer.path = borderPath.CGPath;
    
    self.strokeLayer = [CAShapeLayer layer];
    self.strokeLayer.frame = self.selectModeSwitch.bounds;
    self.strokeLayer.lineWidth = 2.f;
    self.strokeLayer.path = borderPath.CGPath;
    self.strokeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.selectModeSwitch.layer addSublayer:self.strokeLayer];
    
    self.selectModeSwitch.layer.mask = leftLayer;
}

@end