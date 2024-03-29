//
//  HomeDecorationView.h
//  TRA Smart Services
//
//  Created by Admin on 31.07.15.
//

#import "BaseXibView.h"

@class HomeTopBarView;

static CGFloat const LogoScaleMinValue = 0.85f;

@protocol HomeTopBarViewDelegate <NSObject>

@optional
- (void)topBarInformationButtonDidPressedInView:(HomeTopBarView *)parentView;
- (void)topBarSearchButtonDidPressedInView:(HomeTopBarView *)parentView;
- (void)topBarNotificationButtonDidPressedInView:(HomeTopBarView *)parentView;
- (void)topBarLogoImageDidTouched:(HomeTopBarView *)parentView;

@end

@interface HomeTopBarView : BaseXibView

@property (weak, nonatomic) IBOutlet UIView *avatarView;

@property (strong, nonatomic) UIImage *logoImage;
@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) UIImage *informationButtonImage;
@property (strong, nonatomic) UIImage *searchButtonImage;
@property (strong, nonatomic) UIImage *notificationButtonImage;
@property (assign, nonatomic) NSUInteger notificationsCount;
@property (copy, nonatomic) NSString *userInitials;

@property (assign, nonatomic) BOOL disableFakeButtonLayersDrawing;
@property (assign, nonatomic) BOOL isBottomHexagonWireOnTop;

@property (weak, nonatomic) id <HomeTopBarViewDelegate> delegate;

- (void)reverseLayers;
- (void)setStartApearenceAnimationParameters;

- (void)updateUIColor;

- (void)animateOpacityChangesForBottomLayers:(CGFloat)opacityLevel;
- (void)animateBottomWireMovingWithProgress:(CGFloat)progress;
- (void)animateFakeButtonsLayerMovingWithProgress:(CGFloat)progress;
- (void)animateTopViewApearence;
- (void)animateLogoScaling:(CGFloat)scale;

- (void)animateBottomElementsMovingToTop:(BOOL)toTop;
- (void)animateFakeButtonsLayerMovingToTop:(BOOL)toTop;
- (void)scaleLogo:(BOOL)scale;

@end
