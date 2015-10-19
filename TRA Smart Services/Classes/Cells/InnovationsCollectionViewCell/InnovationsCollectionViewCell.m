//
//  InfoHubCollectionViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

#import "InnovationsCollectionViewCell.h"

@interface InnovationsCollectionViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *innovationsPreviewIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *innovationsPreviewedDateDescriptionLabel;

@end

@implementation InnovationsCollectionViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.innovationsPreviewIconImageView.image = nil;
    self.innovationsPreviewDateLabel.text = @"";
    self.innovationsPreviewDescriptionLabel.text = @"";
    self.innovationsPreviewedDateDescriptionLabel.text = @"";
}

#pragma mark - Custom Accessors

- (void)setPreviewLogoImage:(UIImage *)previewLogoImage
{
    _previewLogoImage = previewLogoImage;
    
    self.innovationsPreviewIconImageView.image = previewLogoImage;
    [AppHelper addHexagoneOnView:self.innovationsPreviewIconImageView];
}

- (void)setReviewedData:(NSDate *)reviewedData
{
    _reviewedData = reviewedData;
    
    self.innovationsPreviewedDateDescriptionLabel.text = [self formatDateStringFrom:reviewedData];
}

#pragma mark - Private

- (NSString *)formatDateStringFrom:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" MM / d / yy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    formattedDate = [NSString stringWithFormat:@"%@ -%@", dynamicLocalizedString(@"innovationsCollectionViewCell.string.reviewed"), formattedDate];
    return formattedDate;
}

@end
