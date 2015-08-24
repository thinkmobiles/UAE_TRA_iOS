//
//  AnnoucementsTableViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const AnnoucementsTableViewCellEuropeIdentifier = @"annoucementsCellEuropeUIIdentifier";
static NSString *const AnnoucementsTableViewCellArabicIdentifier = @"annoucementsCellArabicUIIdentifier";

@interface AnnoucementsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *annocementsImageView;
@property (strong, nonatomic) IBOutlet UILabel *annocementsDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *annocementsDateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *marginAnnouncementContainerConstraint;

@end
