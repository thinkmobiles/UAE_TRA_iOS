//
//  FavouriteTableViewCell.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AddToFavouriteTableViewCell.h"

static NSString *const FavIconNameActive = @"check_act";
static NSString *const FavIconNameInActive = @"check_disact";

@interface AddToFavouriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteServiceLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *favourieDescriptionLabel;

@end

@implementation AddToFavouriteTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.favourieDescriptionLabel.text = @"";
    self.favouriteServiceLogoImageView.image = nil;
}

#pragma mark - IBActions

- (IBAction)serviceInfoButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addRemoveFavoriteService:)]) {
        [self.delegate addRemoveFavoriteService:_indexPath];
    }
}

#pragma mark - Custom Accessors

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    _favouriteServiceLogoImageView.image = logoImage;
    [self addHexagoneOnView:self.favouriteServiceLogoImageView];
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    _descriptionText = descriptionText;
    self.favourieDescriptionLabel.text = descriptionText;
}

#pragma mark - Public

- (void)setServiceFavourite:(BOOL)isFavourite
{
    if (isFavourite) {
        UIImage *activeIcon = [UIImage imageNamed:FavIconNameActive];
        if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
            activeIcon = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:activeIcon];
        }
        [self.favoriteButton setImage:activeIcon forState:UIControlStateNormal];
    } else {
        UIImage *inActiveIcon = [UIImage imageNamed:FavIconNameInActive];
        if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
            inActiveIcon = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:inActiveIcon];
        }
        [self.favoriteButton setImage:inActiveIcon forState:UIControlStateNormal];
    }
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