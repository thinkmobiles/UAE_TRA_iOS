//
//  NotificationViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 06.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "NotificationsTableViewCell.h"

@interface NotificationViewController : BaseDynamicUIViewController <UITableViewDataSource, UITableViewDelegate, NotificationsTableViewCellDelegate>

@property (strong, nonatomic) UIImage *fakeBackground;

@end
