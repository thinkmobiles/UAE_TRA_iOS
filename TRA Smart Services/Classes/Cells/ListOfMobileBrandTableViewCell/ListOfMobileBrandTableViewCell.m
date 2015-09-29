//
//  ListOfMobileBrandTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
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
