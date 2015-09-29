//
//  ListOfDevicesTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 28.09.15.
//

static NSString *const ListOfDevicesCellIdentifier = @"ListOfDevicesCell";

@interface ListOfDevicesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginContainerCellConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *deviceHexagonImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleModelDevaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionModelDevaceLabel;

@end
