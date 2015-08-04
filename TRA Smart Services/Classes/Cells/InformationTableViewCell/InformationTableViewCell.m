//
//  InformationTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InformationTableViewCell.h"
#import "RTLController.h"

@implementation InformationTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.informationCellTitle.text = @"";
    self.informationCellText.text= @"";
    self.informationCellImage.image = nil;
}

@end
