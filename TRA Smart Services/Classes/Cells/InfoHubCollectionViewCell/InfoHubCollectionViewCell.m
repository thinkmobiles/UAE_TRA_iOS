//
//  InfoHubCollectionViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InfoHubCollectionViewCell.h"

@implementation InfoHubCollectionViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.announcementPreviewIconImageView.image = nil;
    self.announcementPreviewDateLabel.text = @"";
    self.announcementPreviewDescriptionLabel.text = @"";
}

@end
