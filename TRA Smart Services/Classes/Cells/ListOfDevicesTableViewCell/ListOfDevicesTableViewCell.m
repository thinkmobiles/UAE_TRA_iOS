//
//  ListOfDevicesTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 28.09.15.
//

#import "ListOfDevicesTableViewCell.h"

@implementation ListOfDevicesTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    self.deviceHexagonImageView.image = nil;
    self.titleModelDevaceLabel.text = @"";
    self.descriptionModelDevaceLabel.text = @"";
}

@end
