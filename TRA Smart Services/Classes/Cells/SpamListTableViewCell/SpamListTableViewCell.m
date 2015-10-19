//
//  SpamListTableViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 23.09.15.
//

#import "SpamListTableViewCell.h"

@interface SpamListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *hexView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingImageContainerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tralingImageContainerConstraint;
@property (weak, nonatomic) IBOutlet UIButton *unblockButton;

@end

@implementation SpamListTableViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self updateColors]; 
    [self prepareHexagonLayer];
    self.spamTitleLabel.textColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.logoImageView.image = nil;
    self.spamDescriptionLabel.text = @"";
    self.spamTitleLabel.text = @"";
    self.leadingImageContainerConstraint.constant = 0;
    self.tralingImageContainerConstraint.constant = 0;

    [self updateColors];
    [self prepareHexagonLayer];
}

#pragma mark - Custom Accessors

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    _logoImageView.image = [logoImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - Public

- (void)applyOffsetViewMode
{
    self.leadingImageContainerConstraint.constant = 20;
    self.tralingImageContainerConstraint.constant = 20;
}

#pragma mark - Private

- (void)prepareHexagonLayer
{
    [AppHelper addHexagonBorderForLayer:_hexView.layer color:[[DynamicUIService service] currentApplicationColor] width:1.0f];
}

- (void)updateColors
{
    UIColor *appColor = [[DynamicUIService service] currentApplicationColor];
    [self.logoImageView setTintColor:appColor];
    self.spamTitleLabel.textColor = appColor;
    
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        UIImage *buttonImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:self.unblockButton.imageView.image];
        [self.unblockButton setImage:buttonImage forState:UIControlStateNormal];
    } else {
        [self.unblockButton setImage:[UIImage imageNamed:@"ic_del"] forState:UIControlStateNormal];
    }
}

- (IBAction)unblockButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(unblockButtonDidTappedInCell:)]) {
        [self.delegate unblockButtonDidTappedInCell:self];
    }
}

@end