//
//  ServiceSelectionView.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 17.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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
    self = [super initWithCoder:coder nibName:@"ServiceSelectionView"];
    return self;
}

#pragma mark - Public

- (void)setRTLArabicUIStyle
{
    [self transformUILayer:CATransform3DMakeScale(-1, 1, 1)];
}

- (void)setLTREuropeUIStyle
{
    [self transformUILayer:CATransform3DIdentity];
}

#pragma mark - SetMethods

- (void)setServiceNameReportSMSImage:(UIImage *)image
{
    _serviceNameReportSMSImage = image;
    [self.reportSMSButton setImage:image forState:UIControlStateNormal];
    
}

- (void)setServiceNameReportWEBImage:(UIImage *)image
{
    _serviceNameReportWEBImage = image;
    [self.reportWEBButton setImage:image forState:UIControlStateNormal];
}

- (void)setServiceNameViewMyListImage:(UIImage *)image
{
    _serviceNameViewMyListImage = image;
    [self.viewMyListButton setImage:image forState:UIControlStateNormal];
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

@end
