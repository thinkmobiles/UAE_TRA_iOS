//
//  UserProfileTableViewCell.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 09.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "UserProfileTableViewCell.h"

@implementation UserProfileTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.shevronImageView.tintColor = [[DynamicUIService service] currentApplicationColor];
    self.iconImageView.tintColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.shevronImageView.tintColor = [[DynamicUIService service] currentApplicationColor];
    self.iconImageView.tintColor = [[DynamicUIService service] currentApplicationColor];
    self.titleLabel.text = @"";
    self.iconImageView.image = nil;
}

@end
