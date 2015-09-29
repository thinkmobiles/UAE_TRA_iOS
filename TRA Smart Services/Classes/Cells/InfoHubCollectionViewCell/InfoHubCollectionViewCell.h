//
//  InfoHubCollectionViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

static NSString *const InfoHubCollectionViewCellEuropeIdentifier = @"InfoHubCollectionViewCellEuropeUI";
static NSString *const InfoHubCollectionViewCellArabicIdentifier = @"InfoHubCollectionViewCellArabicUI";

@interface InfoHubCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *announcementPreviewDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *announcementPreviewDescriptionLabel;

@property (strong, nonatomic) UIImage *previewLogoImage;

@end
