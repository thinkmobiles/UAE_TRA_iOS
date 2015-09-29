//
//  ListOfMobileBrandTableViewCell.h
//  TRA Smart Services
//
//  Created by RomaVizenko on 29.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

static NSString *const ListOfMobileBrandCellIdentifier = @"ListOfMobileBrandCell";

@interface ListOfMobileBrandTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginContainerCellConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *deviceHexagonImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoBrandImageView;

@end
