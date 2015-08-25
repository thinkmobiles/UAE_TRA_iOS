//
//  InfoHubTableViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const InfoHubTableViewCellEuropeIdentifier = @"InfoHubTableViewCellEuropeUI";
static NSString *const InfoHubTableViewCellArabicIdentifier = @"InfoHubTableViewCellArabicUI";

@interface InfoHubTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *infoHubTransactionImageView;
@property (strong, nonatomic) IBOutlet UILabel *infoHubTransactionDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoHubTransactionDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoHubTransactionTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginInfoHubContainerConstraint;

@end
