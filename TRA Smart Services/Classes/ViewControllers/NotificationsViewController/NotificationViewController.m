//
//  NotificationViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 06.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "NotificationViewController.h"
#import "Animation.h"

@interface NotificationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderNotificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *informableLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *conteinerView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation NotificationViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.fakeBackground) {
        self.fakeBackgroundImageView.image = self.fakeBackground;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self prepareDataSource];
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
    [self.navigationController popViewControllerAnimated:NO]; // in case of language change - inproper imageWillBe shown :[
}

#pragma mark - CustomAccessors

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    if (self.dataSource.count) {
        self.placeHolderNotificationLabel.hidden = YES;
    } else {
        self.placeHolderNotificationLabel.hidden = NO;
    }
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationsTableViewCell *cell;
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        cell = [tableView dequeueReusableCellWithIdentifier:NotificationsTableViewCellArabicIdentifier forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NotificationsTableViewCellEuropeIdentifier forIndexPath:indexPath];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
}

#pragma mark - NotificationsTableViewCellDelegate

- (void)notificationCellRemoveButtonDidTappedInCell:(NotificationsTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];

    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView endUpdates];
}

#pragma mark - Private

- (void)configureCell:(NotificationsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.notificationDetailsLabel.text = @"Some test details for notifications and some other information can be here";
    cell.notificationTitleLabel.text = @"This is test notification title title title title";
    cell.notificationImageLogo = [UIImage imageNamed:@"test"];
    cell.delegate = self;
}

- (void)prepareDataSource
{
    self.dataSource = [@[@"", @"", @"", @""] mutableCopy];
}

#pragma mark - SuperclassMethods

- (void)updateColors
{
    self.conteinerView.backgroundColor = [[[DynamicUIService service] currentApplicationColor] colorWithAlphaComponent: 0.95f];
}

- (void)localizeUI
{
    self.placeHolderNotificationLabel.text = dynamicLocalizedString(@"notificationsViewController.NotificationPlaceHolderlabel");
    [self displayNotificationsData];
}

- (void)displayNotificationsData
{
    if (self.dataSource.count) {
        self.informableLabel.text = [NSString stringWithFormat:dynamicLocalizedString(@"notificationsViewController.NotificationsMessage"), (int)self.dataSource.count];
    } else {
        self.informableLabel.text = dynamicLocalizedString(@"notificationsViewController.noNotificationsMessage");
    }
}

@end
