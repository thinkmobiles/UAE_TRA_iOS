//
//  SpamListViewController.h
//  TRA Smart Services
//
//  Created by Admin on 23.09.15.
//

#import "BaseSearchableViewController.h"
#import "SpamListTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface SpamListViewController : BaseSearchableViewController <UITableViewDataSource, UITableViewDelegate, SpamListTableViewCellDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) void(^shouldNavigateToSpamReport)();

@end
