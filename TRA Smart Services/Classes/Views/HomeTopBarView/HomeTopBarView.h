//
//  HomeDecorationView.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@class HomeTopBarView;

@protocol HomeTopBarViewDelegate <NSObject>

@optional
- (void)topBarInformationButtonDidPressedInView:(HomeTopBarView *)parentView;
- (void)topBarSearchButtonDidPressedInView:(HomeTopBarView *)parentView;
- (void)topBarNotificationButtonDidPressedInView:(HomeTopBarView *)parentView;

@end

@interface HomeTopBarView : UIView

@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) UIImage *informationButtonImage;
@property (strong, nonatomic) UIImage *searchButtonImage;
@property (strong, nonatomic) UIImage *notificationButtonImage;
@property (assign, nonatomic) NSUInteger notificationsCount;
@property (copy, nonatomic) NSString *userInitials;

@property (weak, nonatomic) id <HomeTopBarViewDelegate> delegate;

- (void)drawWithGradientOpacityLevel:(CGFloat)opacityLevel;
- (void)animationMinimizireButtonTop:(BOOL) minimizire;

@end
