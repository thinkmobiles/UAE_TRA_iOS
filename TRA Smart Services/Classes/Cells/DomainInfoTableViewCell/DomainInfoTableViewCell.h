//
//  DomainInfoTableViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 03.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//


static NSString *const DomainInfoCompactCellIdentifier = @"flatResultTableViewCellIdentifier";
static NSString *const DomainInfoDetailsCellIdentifier = @"detailedResultTableViewCellIdentifier";

@interface DomainInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
