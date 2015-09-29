//
//  HomeSearchResultTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 15.09.15.
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
