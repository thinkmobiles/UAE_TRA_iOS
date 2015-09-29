//
//  ServiceInfoCollectionViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 20.08.15.
//

#import "ServiceInfoCollectionViewCell.h"

@implementation ServiceInfoCollectionViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.serviceInfologoImageView.image = nil;
    self.serviceInfoTitleLabel.text = @"";
}

@end
