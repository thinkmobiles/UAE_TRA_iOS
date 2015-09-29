//
//  AnnoucementsTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

static NSString *const AnnoucementsTableViewCellEuropeIdentifier = @"annoucementsCellEuropeUIIdentifier";
static NSString *const AnnoucementsTableViewCellArabicIdentifier = @"annoucementsCellArabicUIIdentifier";

@interface AnnoucementsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *annocementsDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *annocementsDateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *marginAnnouncementContainerConstraint;

@property (strong, nonatomic) UIImage *annoucementLogoImage;

@end
