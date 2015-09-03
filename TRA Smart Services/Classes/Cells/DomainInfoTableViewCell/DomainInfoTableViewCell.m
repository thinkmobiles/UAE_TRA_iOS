//
//  DomainInfoTableViewCell.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 03.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "DomainInfoTableViewCell.h"

@implementation DomainInfoTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.valueLabel.textColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.typeLabel.text = @"";
    self.valueLabel.text = @"";
    
    self.valueLabel.textColor = [[DynamicUIService service] currentApplicationColor];
}

@end
