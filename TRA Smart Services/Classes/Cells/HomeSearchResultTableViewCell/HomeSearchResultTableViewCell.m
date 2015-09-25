//
//  HomeSearchResultTableViewCell.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 15.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "HomeSearchResultTableViewCell.h"

@implementation HomeSearchResultTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.serviceNameLabel.text = @"";
    self.customAccessoryImageView.image = nil;
}

@end
