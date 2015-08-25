//
//  AnnoucementsTableViewCell.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 18.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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
    [self addHexagoneOnView:self.annocementsImageView];
}

#pragma mark - Private

- (void)addHexagoneOnView:(UIView *)view
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.layer.bounds;
    maskLayer.path = [AppHelper hexagonPathForView:view].CGPath;
    view.layer.mask = maskLayer;
}

@end