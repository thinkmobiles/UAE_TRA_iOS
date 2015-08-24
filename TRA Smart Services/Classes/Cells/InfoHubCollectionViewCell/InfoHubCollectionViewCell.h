//
//  InfoHubCollectionViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const InfoHubCollectionViewCellEuropeIdentifier = @"InfoHubCollectionViewCellEuropeUI";
static NSString *const InfoHubCollectionViewCellArabicIdentifier = @"InfoHubCollectionViewCellArabicUI";

@interface InfoHubCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *announcementPreviewDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *announcementPreviewDescriptionLabel;

@property (strong, nonatomic) UIImage *previewLogoImage;

@end
