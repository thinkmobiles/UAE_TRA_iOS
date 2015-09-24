//
//  SpamListTableViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 23.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

static NSString *const SpamListTableViewCellEuropeIdentifier = @"spamCellEuroIdentifier";
static NSString *const SpamListTableViewCellArabicIdentifier = @"spamCellArabicIdentifier";

@class SpamListTableViewCell;

@protocol SpamListTableViewCellDelegate <NSObject>

@optional
- (void)unblockButtonDidTappedInCell:(SpamListTableViewCell *)cell;

@end

@interface SpamListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *spamTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spamDescriptionLabel;

@property (strong, nonatomic) UIImage *logoImage;

@property (weak, nonatomic) id <SpamListTableViewCellDelegate> delegate;

- (void)applyOffsetViewMode;

@end