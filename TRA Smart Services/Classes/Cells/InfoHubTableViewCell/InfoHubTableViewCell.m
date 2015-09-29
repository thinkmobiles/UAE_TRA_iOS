//
//  InfoHubTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
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
