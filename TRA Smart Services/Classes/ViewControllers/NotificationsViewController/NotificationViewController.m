//
//  NotificationViewController.m
//  TRA Smart Services
//
//  Created by Admin on 06.09.15.
//

#import "NotificationViewController.h"
#import "Animation.h"

@interface NotificationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *fakeBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderNotificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *informableLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *conteinerView;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *conteinerClearAllButtonView;

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
    
//    [self prepareDataSource]; //temp
    [self showPlaceHolderIfNeededAnimated:NO];
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
    [self showPlaceHolderIfNeededAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)tappedClearAllButton:(id)sender
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for(int i = 0; i < [self.dataSource count]; i++) {
        NSIndexPath *anIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:anIndexPath];
    }
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.dataSource removeAllObjects];
    [self.tableView endUpdates];
    
    [self showActiveNotificationStatus];
    [self showPlaceHolderIfNeededAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationsTableViewCell *cell;
    if (self.dynamicService.language == LanguageTypeArabic) {
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
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView endUpdates];
    
    [self showActiveNotificationStatus];
    [self showPlaceHolderIfNeededAnimated:YES];
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

- (void)transformUILayer:(CATransform3D)animCATransform3D
{
    self.topBarView.layer.transform = animCATransform3D;
    self.conteinerClearAllButtonView.layer.transform = animCATransform3D;
    self.clearAllButton.layer.transform = animCATransform3D;
    self.informableLabel.layer.transform = animCATransform3D;
}

- (void)showPlaceHolderIfNeededAnimated:(BOOL)animated
{
    if (self.dataSource.count) {
        self.placeHolderNotificationLabel.hidden = YES;
        self.conteinerClearAllButtonView.layer.opacity = 1.0f;
        self.conteinerClearAllButtonView.hidden = NO;
    } else {
        self.placeHolderNotificationLabel.hidden = NO;
        if (animated) {
            [self.placeHolderNotificationLabel.layer addAnimation:[Animation fadeAnimFromValue:0.f to:1.0f delegate:nil] forKey:nil];
            [self.conteinerClearAllButtonView.layer addAnimation:[Animation fadeAnimFromValue:1.0f to:0.0f delegate:self] forKey:@"keyAnimationPlaceHolder"];
            self.conteinerClearAllButtonView.layer.opacity = 0.0f;
        } else {
            self.conteinerClearAllButtonView.hidden = YES;
        }
    }
}

- (void)showActiveNotificationStatus
{
    if (self.dataSource.count) {
        self.informableLabel.text = [NSString stringWithFormat:dynamicLocalizedString(@"notificationsViewController.NotificationsMessage"), (int)self.dataSource.count];
    } else {
        self.informableLabel.text = dynamicLocalizedString(@"notificationsViewController.noNotificationsMessage");
    }
}

#pragma mark - Animation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.conteinerClearAllButtonView.layer animationForKey:@"keyAnimationPlaceHolder"]) {
        [self.conteinerClearAllButtonView.layer removeAllAnimations];
        self.conteinerClearAllButtonView.hidden = YES;
    }
}

#pragma mark - SuperclassMethods

- (void)updateColors
{
    self.conteinerView.backgroundColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent: 0.95f];
}

- (void)localizeUI
{
    self.placeHolderNotificationLabel.text = dynamicLocalizedString(@"notificationsViewController.NotificationPlaceHolderlabel");
    [self.clearAllButton setTitle:dynamicLocalizedString(@"notificationsViewController.clearAllButton.title") forState:UIControlStateNormal];
    [self showActiveNotificationStatus];
}

- (void)setRTLArabicUI
{
    [self transformUILayer:TRANFORM_3D_SCALE];
    self.informableLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setLTREuropeUI
{
    [self transformUILayer:CATransform3DIdentity];
    self.informableLabel.textAlignment = NSTextAlignmentRight;
}

@end
