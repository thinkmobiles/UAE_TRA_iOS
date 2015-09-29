//
//  ListOfDevicesTableViewCell.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 28.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
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
