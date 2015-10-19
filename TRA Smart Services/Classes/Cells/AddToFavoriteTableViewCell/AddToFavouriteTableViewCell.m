//
//  FavouriteTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 17.08.15.
//

#import "AddToFavouriteTableViewCell.h"

static NSString *const FavIconNameActiveOrange = @"check_act";
static NSString *const FavIconNameInActiveOrange = @"check_disact";
static NSString *const FavIconNameActiveBlue = @"check_blue_act";
static NSString *const FavIconNameInActiveBlue = @"check_blue";
static NSString *const FavIconNameActiveGreen = @"check_green_act";
static NSString *const FavIconNameInActiveGreen = @"check_green";


@interface AddToFavouriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteServiceLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *favourieDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *hexagonBackgroundView;

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
    [AppHelper addHexagoneOnView:self.hexagonBackgroundView];
    [AppHelper addHexagonBorderForLayer:self.hexagonBackgroundView.layer color:[UIColor grayBorderTextFieldTextColor] width:3.0f];
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
        UIImage *activeIcon = [UIImage imageNamed:FavIconNameActiveOrange];
        if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
            activeIcon = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:activeIcon];
        } else if ([DynamicUIService service].colorScheme == ApplicationColorGreen) {
            activeIcon = [UIImage imageNamed:FavIconNameActiveGreen];
        } else if ([DynamicUIService service].colorScheme == ApplicationColorBlue) {
            activeIcon = [UIImage imageNamed:FavIconNameActiveBlue];
        }
        [self.favoriteButton setImage:activeIcon forState:UIControlStateNormal];
    } else {
        UIImage *inActiveIcon = [UIImage imageNamed:FavIconNameInActiveOrange];
        if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
            inActiveIcon = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:inActiveIcon];
        } else if ([DynamicUIService service].colorScheme == ApplicationColorGreen) {
            inActiveIcon = [UIImage imageNamed:FavIconNameInActiveGreen];
        } else if ([DynamicUIService service].colorScheme == ApplicationColorBlue) {
            inActiveIcon = [UIImage imageNamed:FavIconNameInActiveBlue];
        }

        [self.favoriteButton setImage:inActiveIcon forState:UIControlStateNormal];
    }
}

@end