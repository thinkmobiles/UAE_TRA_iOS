//
//  InfoHubTableViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const InnovationsTableViewCellEuropeIdentifier = @"InnovationsTableViewCellEuropeUI";
static NSString *const InnovationsTableViewCellArabicIdentifier = @"InnovationsTableViewCellArabicUI";

@interface InnovationsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *innovationsTransactionImageView;
@property (strong, nonatomic) IBOutlet UILabel *innovationsTransactionDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *innovationsTransactionDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *innovationsTransactionTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginInnovationsContainerConstraint;

@end
