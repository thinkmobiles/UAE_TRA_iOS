//
//  NotificationsTableViewCell.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 06.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "NotificationsTableViewCell.h"

@interface NotificationsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;

@end

@implementation NotificationsTableViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.notificationDetailsLabel.text = @"";
    self.notificationTitleLabel.text = @"";
    self.notificationImageView.image = nil;
}

#pragma mark - CustomAccessors

- (void)setNotificationImageLogo:(UIImage *)notificationImageLogo
{
    _notificationImageLogo = notificationImageLogo;
    
    self.notificationImageView.image = self.notificationImageLogo;
    [self addHexagoneOnView:self.notificationImageView];
}

#pragma mark - IBActions

- (IBAction)removeButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(notificationCellRemoveButtonDidTappedInCell:)]) {
        [self.delegate notificationCellRemoveButtonDidTappedInCell:self];
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
