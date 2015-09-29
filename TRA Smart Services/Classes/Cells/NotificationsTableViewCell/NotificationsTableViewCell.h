//
//  NotificationsTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 06.09.15.
//

static NSString *const NotificationsTableViewCellEuropeIdentifier = @"notificationCellEurope";
static NSString *const NotificationsTableViewCellArabicIdentifier = @"notificationCellArabic";

@class NotificationsTableViewCell;

@protocol NotificationsTableViewCellDelegate <NSObject>

@optional
- (void)notificationCellRemoveButtonDidTappedInCell:(NotificationsTableViewCell *)cell;

@end

@interface NotificationsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notificationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationDetailsLabel;

@property (weak, nonatomic) id <NotificationsTableViewCellDelegate> delegate;
@property (strong, nonatomic) UIImage *notificationImageLogo;

@end
