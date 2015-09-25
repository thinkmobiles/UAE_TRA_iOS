//
//  InfoHubCollectionViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InfoHubCollectionViewCell.h"

@interface InfoHubCollectionViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *announcementPreviewIconImageView;

@end

@implementation InfoHubCollectionViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.announcementPreviewIconImageView.image = nil;
    self.announcementPreviewDateLabel.text = @"";
    self.announcementPreviewDescriptionLabel.text = @"";
}

#pragma mark - Custom Accessors

- (void)setPreviewLogoImage:(UIImage *)previewLogoImage
{
    _previewLogoImage = previewLogoImage;
    
    self.announcementPreviewIconImageView.image = previewLogoImage;
    [AppHelper addHexagoneOnView:self.announcementPreviewIconImageView];
}

@end
