//
//  ServicesSelectTableViewCell.m
//  TRA Smart Services
//
//  Created by Roma on 07.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "ServicesSelectTableViewCell.h"

@implementation ServicesSelectTableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.selectProviderLabel.text = @"";
    self.selectProviderImage.image = nil;
}

@end
