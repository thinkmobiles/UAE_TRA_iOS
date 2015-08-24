//
//  AnnoucementsTableViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AnnoucementsTableViewCell.h"

@implementation AnnoucementsTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.annocementsImageView = nil;
    self.annocementsDateLabel.text = @"";
    self.annocementsDescriptionLabel.text = @"";
}

@end
