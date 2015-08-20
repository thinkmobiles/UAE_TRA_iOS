//
//  ServiceInfoCollectionViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const ServiceInfoCollectionViewCellIdentifier = @"serviceInfoCell";

@interface ServiceInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *serviceInfologoImageView;

@end
