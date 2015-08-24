//
//  ServiceInfoCollectionViewCell.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 20.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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
