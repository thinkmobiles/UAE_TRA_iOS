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
@property (weak, nonatomic) IBOutlet UILabel *favourieDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *favouriteServiceLogoImageViewArabic;
@property (weak, nonatomic) IBOutlet UILabel *favouriteDescriptionArabicLabel;
@property (weak, nonatomic) IBOutlet UIButton *serviceInfoArabicButton;

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
    self.favouriteDescriptionArabicLabel.text = @"";
    self.favouriteServiceLogoImageViewArabic.image = nil;
//    self.removeButton.selected = NO;
//    self.removeArabicButton.selected = NO;
}

#pragma mark - IBActions

- (IBAction)serviceInfoButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(favouriteServiceInfoButtonDidPressedInCell:)]) {
        [self.delegate favouriteServiceInfoButtonDidPressedInCell:self];
    }
}

- (void)markRemoveButtonSelected:(BOOL)selected
{
    if (selected) {
        [self.removeButton setTintColor:[UIColor redColor]];
        [self.removeButton setImage:[UIImage imageNamed:@"ic_remove_act"] forState:UIControlStateNormal];
        [self.removeArabicButton setTintColor:[UIColor redColor]];
        [self.removeArabicButton setImage:[UIImage imageNamed:@"ic_remove_act"] forState:UIControlStateNormal];
    } else {
        [self.removeButton setTintColor:[UIColor lightGrayColor]];
        [self.removeButton setImage:[UIImage imageNamed:@"ic_remove_dctv"] forState:UIControlStateNormal];
        [self.removeArabicButton setTintColor:[UIColor lightGrayColor]];
        [self.removeArabicButton setImage:[UIImage imageNamed:@"ic_remove_dctv"] forState:UIControlStateNormal];
    }
}

#pragma mark - Custom Accessors

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    _favouriteServiceLogoImageView.image = logoImage;
    _favouriteServiceLogoImageViewArabic.image = logoImage;
    [self addHexagoneMaskForLayer:self.favouriteServiceLogoImageView.layer];
    [self addHexagoneMaskForLayer:self.favouriteServiceLogoImageViewArabic.layer];
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    _descriptionText = descriptionText;
    
    self.favourieDescriptionLabel.text = descriptionText;
    self.favouriteDescriptionArabicLabel.text = descriptionText;
}

#pragma mark - Private

- (void)localizeButtons
{
    [self.serviceInfoButton setTitle:dynamicLocalizedString(@"favouriteCell.infoButton.title") forState:UIControlStateNormal];
    [self.removeButton setTitle:dynamicLocalizedString(@"favouriteCell.deleteButton.title") forState:UIControlStateNormal];
    
    [self.serviceInfoArabicButton setTitle:dynamicLocalizedString(@"favouriteCell.infoButton.title") forState:UIControlStateNormal];
    [self.removeArabicButton setTitle:dynamicLocalizedString(@"favouriteCell.deleteButton.title") forState:UIControlStateNormal];
}

- (void)addHexagoneMaskForLayer:(CALayer *)layer
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = layer.bounds;
    maskLayer.path = [AppHelper hexagonPathForView:self.favouriteServiceLogoImageView].CGPath;
    layer.mask = maskLayer;
}

@end