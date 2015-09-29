//
//  ServiceInfoCollectionViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 20.08.15.
//

static NSString *const ServiceInfoCollectionViewCellIdentifier = @"serviceInfoCell";

@interface ServiceInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *serviceInfologoImageView;

@end
