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
@property (weak, nonatomic) IBOutlet UIButton *serviceInfoArabicButton;

@end

@implementation FavouriteTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self localizeAndPrepareButtons];
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self localizeAndPrepareButtons];
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

- (void)markRemoveButtonSelected:(BOOL)selected
{
    UIColor *selectionColor = [UIColor redColor];
    UIImage *actRemoveImage = [UIImage imageNamed:@"ic_remove_act"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        selectionColor = [[[DynamicUIService service] currentApplicationColor] colorWithAlphaComponent:0.8f];
        actRemoveImage = [UIImage imageNamed:@"ic_remove_dctv"];
    }

    if (selected) {
        [self prepareButton:self.removeButton withColor:selectionColor image:actRemoveImage];
        [self prepareButton:self.removeArabicButton withColor:selectionColor image:actRemoveImage];
    } else {
        UIColor *inactColor = [UIColor lightGrayColor];
        UIImage *inactImage = [UIImage imageNamed:@"ic_remove_dctv"];
        [self prepareButton:self.removeButton withColor:inactColor image:inactImage];
        [self prepareButton:self.removeArabicButton withColor:inactColor image:inactImage];
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
    self.favourieDescriptionLabel.tag = DeclineTagForFontUpdate;
}

#pragma mark - Private


- (void)localizeAndPrepareButtons
{
    CGFloat fontSize = [DynamicUIService service].fontSize == ApplicationFontBig ? 10 * 1.1 : 10 * 0.9;
    
    [self.serviceInfoButton setTitle:dynamicLocalizedString(@"favouriteCell.infoButton.title") forState:UIControlStateNormal];
    [self.removeButton setTitle:dynamicLocalizedString(@"favouriteCell.deleteButton.title") forState:UIControlStateNormal];
    [self.serviceInfoArabicButton setTitle:dynamicLocalizedString(@"favouriteCell.infoButton.title") forState:UIControlStateNormal];
    [self.removeArabicButton setTitle:dynamicLocalizedString(@"favouriteCell.deleteButton.title") forState:UIControlStateNormal];
    
    UIFont *europeanButtonFont = [UIFont fontWithName:@"Helvetica" size:fontSize];
    UIFont *arabicButtonFont = [UIFont droidKufiRegularFontForSize:fontSize];
    
    self.serviceInfoArabicButton.titleLabel.font = arabicButtonFont;
    self.removeArabicButton.titleLabel.font = arabicButtonFont;
    self.serviceInfoButton.titleLabel.font = europeanButtonFont;
    self.removeButton.titleLabel.font = europeanButtonFont;

    if ([DynamicUIService service].language == LanguageTypeArabic) {
        CGFloat spacing = 5.f;
        NSDictionary *attributes = @{ NSFontAttributeName : arabicButtonFont };
        
        NSString *removeTitle = dynamicLocalizedString(@"favouriteCell.deleteButton.title");
        CGSize titleSize = [removeTitle sizeWithAttributes:attributes];
        CGFloat removeImageWidth = self.removeArabicButton.imageView.image.size.width;
        self.removeArabicButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleSize.width - spacing);
        self.removeArabicButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, removeImageWidth + spacing);

        NSString *infoTitle = dynamicLocalizedString(@"favouriteCell.infoButton.title");
        CGSize infoSize = [infoTitle sizeWithAttributes:attributes];
        CGFloat infoImageWidth = self.serviceInfoArabicButton.imageView.image.size.width;
        self.serviceInfoArabicButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - infoSize.width - spacing);
        self.serviceInfoArabicButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, infoImageWidth + spacing);
    }
}

- (void)addHexagoneOnView:(UIView *)view
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.layer.bounds;
    maskLayer.path = [AppHelper hexagonPathForView:view].CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - Gestures

- (void)addGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGesture:)];
    [self.removeArabicButton addGestureRecognizer:longPressGesture];
    [self.removeButton addGestureRecognizer:longPressGesture];
}

- (void)longTapGesture:(UILongPressGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(favouriteServiceDeleteButtonDidReceiveGestureRecognizerInCell:gesture:)]) {
        [self.delegate favouriteServiceDeleteButtonDidReceiveGestureRecognizerInCell:self gesture:gesture];
    }
}

@end