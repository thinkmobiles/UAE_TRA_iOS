//
//  ServiceHeaderView.h
//  TRA Smart Services
//
//  Created by Admin on 17.09.15.
//

#import "BaseXibView.h"

@interface ServiceHeaderView : BaseXibView

@property (weak, nonatomic) IBOutlet UILabel *serviceHeaderLabel;
@property (strong, nonatomic) UIImage *serviceHeaderImage;

- (void)updateUIColor;

@end
