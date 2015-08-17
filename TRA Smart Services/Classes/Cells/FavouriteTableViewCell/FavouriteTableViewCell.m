//
//  FavouriteTableViewCell.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "FavouriteTableViewCell.h"

@interface FavouriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *serviceInfoButton;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteServiceLogoImageView;

@end

@implementation FavouriteTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self localizeButtons];
    self.backgroundColor = [UIColor clearColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self localizeButtons];
    self.backgroundColor = [UIColor clearColor];
    self.favourieDescriptionLabel.text = @"";
    self.favouriteServiceLogoImageView.image = nil;
}

#pragma mark - IBActions

- (IBAction)serviceInfoButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(favouriteServiceInfoButtonDidPressedInCell:)]) {
        [self.delegate favouriteServiceInfoButtonDidPressedInCell:self];
    }
}

#pragma mark - Custom Accessors

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    _favouriteServiceLogoImageView.image = logoImage;
    [self addHexagoneMaskForLayer:self.favouriteServiceLogoImageView.layer];
}

#pragma mark - Private

- (void)localizeButtons
{
    [self.serviceInfoButton setTitle:dynamicLocalizedString(@"favouriteCell.infoButton.title") forState:UIControlStateNormal];
    [self.removeButton setTitle:dynamicLocalizedString(@"favouriteCell.deleteButton.title") forState:UIControlStateNormal];
}

- (void)addHexagoneMaskForLayer:(CALayer *)layer
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = layer.bounds;
    maskLayer.path = [AppHelper hexagonPathForView:self.favouriteServiceLogoImageView].CGPath;
    layer.mask = maskLayer;
}

@end