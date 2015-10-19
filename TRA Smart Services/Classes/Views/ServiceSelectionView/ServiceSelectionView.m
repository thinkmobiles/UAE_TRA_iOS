//
//  ServiceSelectionView.m
//  TRA Smart Services
//
//  Created by Admin on 17.09.15.
//

#import "ServiceSelectionView.h"

@interface ServiceSelectionView()

@property (weak, nonatomic) IBOutlet UIButton *reportSMSButton;
@property (weak, nonatomic) IBOutlet UIButton *reportWEBButton;
@property (weak, nonatomic) IBOutlet UIButton *viewMyListButton;

@end

@implementation ServiceSelectionView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder nibName:NSStringFromClass([self class])];
    return self;
}

#pragma mark - Public

- (void)setRTLArabicUIStyle
{
    [self transformUILayer:TRANFORM_3D_SCALE];
}

- (void)setLTREuropeUIStyle
{
    [self transformUILayer:CATransform3DIdentity];
}

- (void)updateUIColor
{
    [self applyImage:self.serviceNameReportSMSImage forButton:self.reportSMSButton];
    [self applyImage:self.serviceNameReportWEBImage forButton:self.reportWEBButton];
    [self applyImage:self.serviceNameViewMyListImage forButton:self.viewMyListButton];
    
    [self setDefaultTintColorsForButtonsIfNeeded];
    
    [self setupLabelTextColor];
}

#pragma mark - SetMethods

- (void)setServiceNameReportSMSImage:(UIImage *)image
{
    _serviceNameReportSMSImage = image;
    [self applyImage:image forButton:self.reportSMSButton];
}

- (void)setServiceNameReportWEBImage:(UIImage *)image
{
    _serviceNameReportWEBImage = image;
    [self applyImage:image forButton:self.reportWEBButton];
}

- (void)setServiceNameViewMyListImage:(UIImage *)image
{
    _serviceNameViewMyListImage = image;
    [self applyImage:image forButton:self.viewMyListButton];
}

#pragma mark - IBAction

- (IBAction)reportSMSTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonReportSMSDidTapped)]) {
        [self.delegate buttonReportSMSDidTapped];
    }
}

- (IBAction)reportWEBTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonReportWEBDidTapped)]) {
        [self.delegate buttonReportWEBDidTapped];
    }
}

- (IBAction)viewMyListTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonViewMyListDidTapped)]) {
        [self.delegate buttonViewMyListDidTapped];
    }
}

#pragma mark - Private

- (void)transformUILayer:(CATransform3D)animCATransform3D
{
    self.reportSMSLabel.layer.transform = animCATransform3D;
    self.reportWEBLabel.layer.transform = animCATransform3D;
    self.viewMyListLabel.layer.transform = animCATransform3D;
    self.layer.transform = animCATransform3D;
}

- (void)applyImage:(UIImage *)image forButton:(UIButton *)button
{
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        image = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:image];
        [button setTintColor:[UIColor blackColor]];
    }
    [button setImage:image forState:UIControlStateNormal];
}

- (void)setDefaultTintColorsForButtonsIfNeeded
{
    if ([DynamicUIService service].colorScheme != ApplicationColorBlackAndWhite) {
        [self.reportSMSButton setTintColor:[UIColor defaultOrangeColor]];
        [self.reportWEBButton setTintColor:[UIColor defaultGreenColor]];
        [self.viewMyListButton setTintColor:[UIColor defaultBlueColor]];
    }
}

- (void)setupLabelTextColor
{
    BOOL isBlackAndWhite = [DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite;
    UIColor *color = [[DynamicUIService service] currentApplicationColor];
    self.reportSMSLabel.textColor = isBlackAndWhite ? color : [UIColor defaultOrangeColor];
    self.reportWEBLabel.textColor = isBlackAndWhite ? color : [UIColor defaultGreenColor];
    self.viewMyListLabel.textColor = isBlackAndWhite ? color : [UIColor defaultBlueColor];
}

@end
