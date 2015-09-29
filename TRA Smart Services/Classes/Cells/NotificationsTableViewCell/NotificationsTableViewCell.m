//
//  NotificationsTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 06.09.15.
//

#import "NotificationsTableViewCell.h"

@interface NotificationsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;

@end

@implementation NotificationsTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.notificationDetailsLabel.text = @"";
    self.notificationTitleLabel.text = @"";
    self.notificationImageView.image = nil;
}

#pragma mark - CustomAccessors

- (void)setNotificationImageLogo:(UIImage *)notificationImageLogo
{
    _notificationImageLogo = notificationImageLogo;
    
    self.notificationImageView.image = self.notificationImageLogo;
    [AppHelper addHexagoneOnView:self.notificationImageView];
}

#pragma mark - IBActions

- (IBAction)removeButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(notificationCellRemoveButtonDidTappedInCell:)]) {
        [self.delegate notificationCellRemoveButtonDidTappedInCell:self];
    }
}

@end