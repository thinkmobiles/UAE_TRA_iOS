//
//  InfoHubCollectionViewCell.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

static NSString *const InnovationsCollectionViewCellEuropeIdentifier = @"InnovationsCollectionViewCellEuropeUI";
static NSString *const InnovationsCollectionViewCellArabicIdentifier = @"InnovationsCollectionViewCellArabicUI";

@interface InnovationsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *innovationsPreviewDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *innovationsPreviewDescriptionLabel;
@property (strong, nonatomic) NSDate *reviewedData;

@property (strong, nonatomic) UIImage *previewLogoImage;

@end
