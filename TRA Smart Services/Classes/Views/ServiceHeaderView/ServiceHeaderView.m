//
//  ServiceHeaderView.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 17.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "ServiceHeaderView.h"

@interface ServiceHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation ServiceHeaderView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder nibName:NSStringFromClass([self class])];
    return self;
}

#pragma mark - Public

- (void)updateUIColor
{
    [self prepareImageView];
}

#pragma mark - SetMethods

- (void)setServiceHeaderImage:(UIImage *)serviceHeaderImage
{
    _serviceHeaderImage = serviceHeaderImage;
    [self prepareImageView];
}

- (void)prepareImageView
{
    UIImage *image = self.serviceHeaderImage;
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        image = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:image];
    }
    self.headerImageView.image = image;
}

@end
