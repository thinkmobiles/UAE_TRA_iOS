//
//  ServicesSelectTableViewCell.h
//  TRA Smart Services
//
//  Created by Roma on 07.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const selectProviderCellEuropeUIIdentifier = @"selectProviderCellEuropeUI";
static NSString *const selectProviderCellArabicUIIdentifier = @"selectProviderCellArabicUI";

@interface ServicesSelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *selectProviderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectProviderImage;

@end
