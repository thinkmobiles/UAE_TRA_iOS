//
//  InfoHubTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
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
