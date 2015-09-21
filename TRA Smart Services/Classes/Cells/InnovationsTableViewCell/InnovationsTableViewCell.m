//
//  InfoHubTableViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InnovationsTableViewCell.h"

@implementation InnovationsTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.innovationsTransactionImageView.image = nil;
    self.innovationsTransactionDescriptionLabel.text = @"";
    self.innovationsTransactionDateLabel.text = @"";
    self.innovationsTransactionTitleLabel.text = @"";
}

@end
