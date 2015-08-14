//
//  InformationHeaderCell.h
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const InformationHeaderCellIdentifier = @"infoHeader";

@interface InformationHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *informationHeaderText;

@end