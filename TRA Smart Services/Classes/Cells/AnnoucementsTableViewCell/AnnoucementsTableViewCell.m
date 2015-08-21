//
//  AnnoucementsTableViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AnnoucementsTableViewCell.h"

@implementation AnnoucementsTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.annocementsImage = nil;
    self.annocementsDate.text = @"";
    self.annocementsText.text = @"";
}

@end
