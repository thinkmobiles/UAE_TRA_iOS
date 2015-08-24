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
    
    self.image.image = nil;
    self.dateLabel.text = @"";
    self.textLabel.text = @"";
}

@end
