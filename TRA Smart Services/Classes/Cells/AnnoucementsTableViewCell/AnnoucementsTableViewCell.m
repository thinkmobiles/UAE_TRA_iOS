//
//  AnnoucementsTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

#import "AnnoucementsTableViewCell.h"

@interface AnnoucementsTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *annocementsImageView;

@end

@implementation AnnoucementsTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.annocementsImageView = nil;
    self.annocementsDateLabel.text = @"";
    self.annocementsDescriptionLabel.text = @"";
}

#pragma mark - Custom Accessors

- (void)setAnnoucementLogoImage:(UIImage *)annoucementLogoImage
{
    _annoucementLogoImage = annoucementLogoImage;
    
    self.annocementsImageView.image = annoucementLogoImage;
    [AppHelper addHexagoneOnView:self.annocementsImageView];
}

@end