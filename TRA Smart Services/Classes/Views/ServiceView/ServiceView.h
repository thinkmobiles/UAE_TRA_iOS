//
//  ServiceView.h
//  TRA Smart Services
//
//  Created by Anatoliy Dalekorey on 9/2/15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseXibView.h"

@interface ServiceView : BaseXibView

@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImage;

@end
