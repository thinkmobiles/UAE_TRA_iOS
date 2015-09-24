//
//  SpamListViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 23.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "BaseSearchableViewController.h"
#import "SpamListTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface SpamListViewController : BaseSearchableViewController <UITableViewDataSource, UITableViewDelegate, SpamListTableViewCellDelegate, MFMessageComposeViewControllerDelegate>

@end
