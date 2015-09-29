//
//  ListOfMobileBrandTableViewCell.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 29.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "ListOfMobileBrandTableViewCell.h"

@implementation ListOfMobileBrandTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    self.deviceHexagonImageView.image = nil;
    self.logoBrandImageView.image = nil;
}

@end
