//
//  UserProfileTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 09.09.15.
//

static NSString *const UserProfileTableViewCellEuropeanCellIdentifier = @"europianUserProfileCell";
static NSString *const UserProfileTableViewCellArabicCellIdentifier = @"arabicUserProfileCell";

@interface UserProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIImageView *shevronImageView;

@end
