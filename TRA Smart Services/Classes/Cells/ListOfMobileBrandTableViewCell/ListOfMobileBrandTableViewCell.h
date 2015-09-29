//
//  ListOfMobileBrandTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

static NSString *const ListOfMobileBrandCellIdentifier = @"ListOfMobileBrandCell";

@interface ListOfMobileBrandTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginContainerCellConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *deviceHexagonImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoBrandImageView;

@end
