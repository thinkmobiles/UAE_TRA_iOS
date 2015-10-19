//
//  ListOfDevicesTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 28.09.15.
//

#import "ListOfDevicesTableViewCell.h"

@interface ListOfDevicesTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *hexagonView;

@end

@implementation ListOfDevicesTableViewCell

#pragma mark - LifeCycle

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [AppHelper addHexagoneOnView:self.hexagonView];
    [AppHelper addHexagonBorderForLayer:self.hexagonView.layer color:[UIColor grayBorderTextFieldTextColor] width:3.0f];
}

- (void)prepareForReuse
{
    self.deviceHexagonImageView.image = nil;
    self.titleModelDevaceLabel.text = @"";
    self.descriptionModelDevaceLabel.text = @"";
}

@end
