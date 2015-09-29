//
//  ListOfDevicesTableViewCell.h
//  TRA Smart Services
//
//  Created by RomaVizenko on 28.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

static NSString *const ListOfDevicesCellIdentifier = @"ListOfDevicesCell";

@interface ListOfDevicesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginContainerCellConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *deviceHexagonImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleModelDevaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionModelDevaceLabel;

@end
