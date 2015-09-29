//
//  FavouriteTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 17.08.15.
//

#import "FavouriteTableViewCell.h"

@interface FavouriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIImageView *removeImageView;
@property (weak, nonatomic) IBOutlet UIButton *serviceInfoButton;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteServiceLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *favourieDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *hexagonBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *serviceInforLabel;
@property (weak, nonatomic) IBOutlet UILabel *removeLabel;

@end

@implementation FavouriteTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self localizeButtons];
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer];
    [self.favouriteServiceLogoImageView setContentMode:UIViewContentModeScaleAspectFit];
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

- (void)markRemoveButtonSelected:(BOOL)selected
{
    UIColor *selectionColor = [UIColor redColor];
    UIImage *actRemoveImage = [UIImage imageNamed:@"ic_remove_act"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        selectionColor = [[[DynamicUIService service] currentApplicationColor] colorWithAlphaComponent:0.8f];
        actRemoveImage = [UIImage imageNamed:@"ic_remove_dctv"];
    }
    self.removeImageView.image = selected ? actRemoveImage : [UIImage imageNamed:@"ic_remove_dctv"];
    self.removeLabel.textColor = selected ? selectionColor : [UIColor lightGrayColor];
}

#pragma mark - Custom Accessors

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    _favouriteServiceLogoImageView.image = logoImage;
    
    [AppHelper addHexagoneOnView:self.hexagonBackgroundView];
    [AppHelper addHexagonBorderForLayer:self.hexagonBackgroundView.layer color:[UIColor grayBorderTextFieldTextColor ] width:3.0f];
    
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    _descriptionText = descriptionText;
    self.favourieDescriptionLabel.text = descriptionText;
    self.favourieDescriptionLabel.tag = DeclineTagForFontUpdate;
}

#pragma mark - Private

- (void)localizeButtons
{
    self.serviceInforLabel.text = dynamicLocalizedString(@"favouriteCell.infoButton.title");
    self.removeLabel.text = dynamicLocalizedString(@"favouriteCell.deleteButton.title");
}

#pragma mark - Gestures

- (void)addGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGesture:)];
    [self.removeButton addGestureRecognizer:longPressGesture];
}

- (void)longTapGesture:(UILongPressGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(favouriteServiceDeleteButtonDidReceiveGestureRecognizerInCell:gesture:)]) {
        [self.delegate favouriteServiceDeleteButtonDidReceiveGestureRecognizerInCell:self gesture:gesture];
    }
}

@end