//
//  DomainInfoTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 03.09.15.
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
