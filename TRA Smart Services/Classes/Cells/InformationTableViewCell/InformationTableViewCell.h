//
//  InformationTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const InformationTableViewCellIdentifier = @"infoCell";

@interface InformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *informationCellImage;
@property (weak, nonatomic) IBOutlet UILabel *informationCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *informationCellText;

@end