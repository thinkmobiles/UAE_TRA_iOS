//
//  FavouriteTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 17.08.15.
//

@class InnovationsChatTableViewCell;

static NSString *const InnovationsChatEuropeCellIdentifier = @"InnovationsChatEuropeCell";
static NSString *const InnovationsChatArabicCellIdentifier = @"InnovationsChatArabicCell";

@protocol InnovationsChatTableViewCellDelegate <NSObject>

@optional
- (void)innovationsChatReplyButtonDidPressedInCell:(InnovationsChatTableViewCell *)cell;
- (void)innovationsChatReportAbuseButtonDidPressedInCell:(InnovationsChatTableViewCell *)cell;

@end

@interface InnovationsChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginInnovationsContainerConstraint;

@property (strong, nonatomic) UIImage *logoImage;
@property (copy, nonatomic) NSString *descriptionText;
@property (copy, nonatomic) NSString *titleText;

@property (weak, nonatomic) id <InnovationsChatTableViewCellDelegate> delegate;

@end