//
//  ServiceView.h
//  TRA Smart Services
//
//  Created by Admin on 9/2/15.
//

#import "BaseXibView.h"

@interface ServiceView : BaseXibView

@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImage;

@end
