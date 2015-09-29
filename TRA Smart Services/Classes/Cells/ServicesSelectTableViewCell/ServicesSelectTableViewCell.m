//
//  ServicesSelectTableViewCell.m
//  TRA Smart Services
//
//  Created by Roma on 07.09.15.
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
