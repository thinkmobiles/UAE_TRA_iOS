//
//  DomainInfoTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 03.09.15.
//


static NSString *const DomainInfoCompactCellIdentifier = @"flatResultTableViewCellIdentifier";
static NSString *const DomainInfoDetailsCellIdentifier = @"detailedResultTableViewCellIdentifier";

@interface DomainInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
