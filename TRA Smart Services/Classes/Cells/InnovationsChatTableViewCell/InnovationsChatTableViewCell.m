//
//  FavouriteTableViewCell.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InnovationsChatTableViewCell.h"

@interface InnovationsChatTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *innovationsChatReplyButton;
@property (weak, nonatomic) IBOutlet UIButton *innovationsChatReportAbuseButton;
@property (weak, nonatomic) IBOutlet UIImageView *innovationsChatLogoImageView;
@property (weak, nonatomic) IBOutlet AligmentLabel *innovationsChatDescriptionLabel;
@property (weak, nonatomic) IBOutlet AligmentLabel *innovationsChatTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *hexagonBackgroundView;

@end

@implementation InnovationsChatTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self localizeButtons];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    

    [self localizeButtons];
    
    self.innovationsChatDescriptionLabel.text = @"";
    self.innovationsChatLogoImageView.image = nil;
    self.innovationsChatTitleLabel.text = @"";
}

#pragma mark - IBActions

- (IBAction)replyButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(innovationsChatReplyButtonDidPressedInCell:)]) {
        [self.delegate innovationsChatReplyButtonDidPressedInCell:self];
    }
}

- (IBAction)reportAbuseButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(innovationsChatReportAbuseButtonDidPressedInCell:)]) {
        [self.delegate innovationsChatReportAbuseButtonDidPressedInCell:self];
    }
}

#pragma mark - Custom Accessors

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    self.innovationsChatLogoImageView.image = logoImage;
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    _descriptionText = descriptionText;
    self.innovationsChatDescriptionLabel.text = descriptionText;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.innovationsChatTitleLabel.text = titleText;
}

#pragma mark - Private

- (void)localizeButtons
{
    [self.innovationsChatReplyButton setTitle:@"innovationsChatTableViewCell.replyButton.title" forState:UIControlStateNormal];
    [self.innovationsChatReportAbuseButton setTitle:@"innovationsChatTableViewCell.reportAbuseButton.title" forState:UIControlStateNormal];
}

@end