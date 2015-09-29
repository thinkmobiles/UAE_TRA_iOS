//
//  NotificationViewController.h
//  TRA Smart Services
//
//  Created by Admin on 06.09.15.
//

#import "NotificationsTableViewCell.h"

@interface NotificationViewController : BaseDynamicUIViewController <UITableViewDataSource, UITableViewDelegate, NotificationsTableViewCellDelegate>

@property (strong, nonatomic) UIImage *fakeBackground;

@end
