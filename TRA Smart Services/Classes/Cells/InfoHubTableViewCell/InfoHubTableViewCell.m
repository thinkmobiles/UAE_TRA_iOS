//
//  InfoHubTableViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InfoHubTableViewCell.h"

@implementation InfoHubTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.infoHubTransactionImageView.image = nil;
    self.infoHubTransactionDescriptionLabel.text = @"";
    self.infoHubTransactionDateLabel.text = @"";
    self.infoHubTransactionTitleLabel.text = @"";
}

@end
