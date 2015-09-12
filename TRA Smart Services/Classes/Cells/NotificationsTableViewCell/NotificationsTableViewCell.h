//
//  NotificationsTableViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 06.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const NotificationsTableViewCellEuropeIdentifier = @"notificationCellEurope";
static NSString *const NotificationsTableViewCellArabicIdentifier = @"notificationCellArabic";

@class NotificationsTableViewCell;

@protocol NotificationsTableViewCellDelegate <NSObject>

@optional
- (void)notificationCellRemoveButtonDidTappedInCell:(NotificationsTableViewCell *)cell;

@end

@interface NotificationsTableViewCell : UITableViewCell

@property (weak, nonatomic) id <NotificationsTableViewCellDelegate> delegate;
@property (strong, nonatomic) UIImage *notificationImageLogo;

@property (weak, nonatomic) IBOutlet UILabel *notificationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationDetailsLabel;

@end
