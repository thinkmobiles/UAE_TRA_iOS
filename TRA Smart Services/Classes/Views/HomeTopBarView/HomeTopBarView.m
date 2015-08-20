//
//  HomeDecorationView.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "HomeTopBarView.h"
#import "UIImage+DrawText.h"

static CGFloat const LeftOffset = 10.f;
static CGFloat const ElementsInRowCount = 8.f;
static CGFloat const ElementsColumsCount = 2.f;
static CGFloat const CornerWidthForAvatar = 3.f;

@interface HomeTopBarView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingAvatarViewSpaceConstraint;

@property (strong, nonatomic) CAShapeLayer *hexagonicalTopLayer;
@property (strong, nonatomic) CAShapeLayer *bottomLeftHexagonLayer;
@property (strong, nonatomic) CAShapeLayer *bottomMidHexagonLayer;
@property (strong, nonatomic) CAShapeLayer *bottomRightHexagonLayer;
@property (strong, nonatomic) CAShapeLayer *borderLogoLayer;

@property (strong, nonatomic) CALayer *avatarImageLayer;
@property (strong, nonatomic) CALayer *informationLayer;
@property (strong, nonatomic) CALayer *searchLayer;
@property (strong, nonatomic) CALayer *notificationLayer;

@property (assign, nonatomic) BOOL disableFakeButtonLayersDrawing;
@property (assign, nonatomic) __block BOOL isAppearenceAnimationCompleted;

@property (assign, nonatomic) CGPoint bottomLayerDefaultPosition;

@end

@implementation HomeTopBarView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"HomeTopBarView" owner:self options:nil];
        UIView *view = [nibsArray firstObject];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self addConstraintsForView:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawHexagonicalWireTop];
    [self updateAvatarPosition];
    [self prepareLogoImage];
    
    if (!self.disableFakeButtonLayersDrawing) {
        [self prepareInformationButtonLayer];
        [self prepareSearchButtonLayer];
        [self prepareNotificationButtonLayer];
        [self drawHexagonicalWireBotton];
        
        [self setStartApearenceAnimationParameters];
    }
}

#pragma mark - Override

- (void)touchesBegan:(nonnull NSSet*)touches withEvent:(nullable UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer containsPoint:[self.layer convertPoint:touchPoint toLayer:layer]]) {
            if (layer == self.informationLayer) {
                if ([self.delegate respondsToSelector:@selector(topBarInformationButtonDidPressedInView:)] && self.delegate) {
                    [self.delegate topBarInformationButtonDidPressedInView:self];
                }
                [layer addAnimation:[self layerPressAnimation] forKey:nil];
            } else if (layer == self.searchLayer) {
                if ([self.delegate respondsToSelector:@selector(topBarSearchButtonDidPressedInView:)] && self.delegate) {
                    [self.delegate topBarSearchButtonDidPressedInView:self];
                }
                [layer addAnimation:[self layerPressAnimation] forKey:nil];
            } else if (layer == self.notificationLayer) {
                if ([self.delegate respondsToSelector:@selector(topBarNotificationButtonDidPressedInView:)] && self.delegate) {
                    [self.delegate topBarNotificationButtonDidPressedInView:self];
                }
                [layer addAnimation:[self layerPressAnimation] forKey:nil];
            }
        }
    }
    for (CALayer *layer in self.avatarView.layer.sublayers) {
        if ([layer containsPoint:[self.layer convertPoint:touchPoint toLayer:layer]]) {
            if (layer == self.avatarImageLayer) {
                if ([self.delegate respondsToSelector:@selector(topBarLogoImageDidTouched:)] && self.delegate) {
                    [self.delegate topBarLogoImageDidTouched:self];
                }
            }
        }
    }
}

#pragma mark - CustomAccessors

- (void)setInformationButtonImage:(UIImage *)informationButtonImage
{
    _informationButtonImage = informationButtonImage;
    [self prepareInformationButtonLayer];
}

- (void)setNotificationButtonImage:(UIImage *)notificationButtonImage
{
    _notificationButtonImage = notificationButtonImage;
    [self prepareNotificationButtonLayer];
}

- (void)setSearchButtonImage:(UIImage *)searchButtonImage
{
    _searchButtonImage = searchButtonImage;
    [self prepareSearchButtonLayer];
}

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    [self prepareLogoImage];
}

- (void)setNotificationsCount:(NSUInteger)notificationsCount
{
    _notificationsCount = notificationsCount;
    [self prepareNotificationButtonLayer];
}

- (void)setUserInitials:(NSString *)userInitials
{
    _userInitials = userInitials;
    [self prepareLogoImage];
}

#pragma mark - Public

- (void)reverseLayers
{
    self.notificationLayer.transform = CATransform3DMakeScale(-1, 1, 1);
    self.searchLayer.transform = CATransform3DMakeScale(-1, 1, 1);
    self.informationLayer.transform = CATransform3DMakeScale(-1, 1, 1);
}

- (void)updateOpacityForHexagons:(CGFloat)opacityLevel
{
    if (self.isAppearenceAnimationCompleted) {
        self.bottomLeftHexagonLayer.opacity = 1 - opacityLevel;
        self.bottomMidHexagonLayer.opacity = 1 - opacityLevel;
        self.bottomRightHexagonLayer.opacity = 1 - opacityLevel;
    }
}

- (void)moveFakeButtonsToTop:(BOOL)moveToTop
{
    if (self.enableFakeBarAnimations && [self enebleAnimation:moveToTop]) {
        self.isFakeButtonsOnTop = moveToTop;
        self.enableFakeBarAnimations = NO;
        self.disableFakeButtonLayersDrawing = YES;
        CGPoint endAnimValueInformationLayer = [self calculateEndPositionForInformationLayerWithMInizizedLayout:moveToTop];
        CGPoint endAnimValueNotificationLayer = [self calculateEndPositionForNotificationLayerWithMInizizedLayout:moveToTop];
        
        CABasicAnimation *animationInformationLayer = [self animationPositionStart:self.informationLayer.position positionEnd:endAnimValueInformationLayer];
        self.informationLayer.position = endAnimValueInformationLayer;
        [self.informationLayer addAnimation:animationInformationLayer forKey:@"animationInformationLayer"];
        
        CABasicAnimation *animationNotificationLayer = [self animationPositionStart:self.notificationLayer.position positionEnd:endAnimValueNotificationLayer];
        self.notificationLayer.position = endAnimValueNotificationLayer;
        [self.notificationLayer addAnimation:animationNotificationLayer forKey:@"animationNotificationLayer"];
    }
}

- (void)scaleLogo:(BOOL)scale
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transformation = CATransform3DIdentity;
    transformation = scale ? CATransform3DIdentity : CATransform3DScale(transformation, LogoScaleMinValue, LogoScaleMinValue, 1);
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:self.avatarImageLayer.transform];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:transformation];
    scaleAnimation.duration = 0.25;
    [self.avatarImageLayer addAnimation:scaleAnimation forKey:nil];
    self.avatarImageLayer.transform = transformation;
}

- (void)scaleLogoFor:(CGFloat)scale
{
    CATransform3D transformation = CATransform3DIdentity;
    transformation = CATransform3DScale(transformation, scale, scale, 1);
    self.avatarImageLayer.transform = transformation;
}

- (void)moveBottomHexagonWireToTop:(BOOL)toTop
{
    [self moveBottomLeftHexagonToTop:toTop];
    [self moveLayer:self.bottomMidHexagonLayer toTop:toTop];
    [self moveLayer:self.bottomRightHexagonLayer toTop:toTop];
    self.isBottomHexagonWireOnTop = toTop;
}

- (void)updatedPositionForBottomWireForMovingProgress:(CGFloat)progress
{
    CGSize hexagonSize = [self hexagonOnWireSize];
    CGFloat maximumXOffset = hexagonSize.width * 0.5f;
    CGFloat maximumYOffset = hexagonSize.height * 0.75f;
    
    CGFloat currentXOffset = maximumXOffset * progress;
    CGFloat currentYOffset = maximumYOffset * progress;
    
    self.bottomLeftHexagonLayer.position = CGPointMake(self.bottomLayerDefaultPosition.x - currentXOffset, self.bottomLayerDefaultPosition.y - currentYOffset);
    self.bottomMidHexagonLayer.position = CGPointMake(self.bottomLayerDefaultPosition.x + currentXOffset, self.bottomLayerDefaultPosition.y - currentYOffset);
    self.bottomRightHexagonLayer.position = CGPointMake(self.bottomLayerDefaultPosition.x + currentXOffset, self.bottomLayerDefaultPosition.y - currentYOffset);
}

- (void)animateTopViewApearence
{
    CGFloat AnimationTimeForLine = 0.3f;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = AnimationTimeForLine;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];

    __weak typeof(self) weakSelf = self;
    CGFloat delayForTopDrawing = 0.05;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForTopDrawing * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.hexagonicalTopLayer addAnimation:pathAnimation forKey:nil];
        [weakSelf.avatarImageLayer addAnimation:pathAnimation forKey:nil];
        weakSelf.hexagonicalTopLayer.opacity = 1.0f;
        weakSelf.avatarImageLayer.opacity = 1.f;
    });
    
    CGFloat delayForInfoDrawing = AnimationTimeForLine * (6. / 8.);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForInfoDrawing * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.informationLayer.opacity = 1.f;
    });
    
    CGFloat delayForSearchDrawing = AnimationTimeForLine * (7. / 8.);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForSearchDrawing * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.searchLayer.opacity = 1.f;
    });
    
    CGFloat delayForRightBottomPart = AnimationTimeForLine;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForRightBottomPart * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.bottomRightHexagonLayer.opacity = 1.f;
        [weakSelf.bottomRightHexagonLayer addAnimation:pathAnimation forKey:nil];
    });
    
    CGFloat delayForNotificationLayer = AnimationTimeForLine + AnimationTimeForLine * (1 / 8.);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForNotificationLayer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.notificationLayer.opacity = 1.f;
    });

    CGFloat delayForMidBottomPart = delayForRightBottomPart + AnimationTimeForLine * (5. / 6.);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForMidBottomPart * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.bottomMidHexagonLayer.opacity = 1.f;
        [weakSelf.bottomMidHexagonLayer addAnimation:pathAnimation forKey:nil];
    });
    
    CGFloat delayForLeftBottomPart = delayForMidBottomPart + AnimationTimeForLine * (1 / 8.);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayForLeftBottomPart * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.bottomLeftHexagonLayer.opacity = 1.f;
        pathAnimation.delegate = self;
        pathAnimation.removedOnCompletion = NO;
        [weakSelf.bottomLeftHexagonLayer addAnimation:pathAnimation forKey:@"lastTopAppearenceAnimation"];
    });
}

- (void)setStartApearenceAnimationParameters
{
    self.informationLayer.opacity = 0.f;
    self.searchLayer.opacity = 0.f;
    self.notificationLayer.opacity = 0.f;
    self.bottomRightHexagonLayer.opacity = 0.f;
    self.bottomMidHexagonLayer.opacity = 0.f;
    self.bottomLeftHexagonLayer.opacity = 0.f;
    
    self.hexagonicalTopLayer.opacity = 0.0f;
    self.avatarImageLayer.opacity = 0.f;

    self.isAppearenceAnimationCompleted = NO;
}

- (void)updateUIColor;
{
    struct CGColor *color = [DynamicUIService service].currentApplicationColor.CGColor;
    self.informationLayer.backgroundColor = color;
    self.searchLayer.backgroundColor = color;
    self.notificationLayer.backgroundColor = color;
}

#pragma mark - AnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.notificationLayer animationForKey:@"animationNotificationLayer"]) {
        [self.notificationLayer removeAllAnimations];
        self.enableFakeBarAnimations = YES;
    }
    if (anim == [self.informationLayer animationForKey:@"animationInformationLayer"]) {
        [self.informationLayer removeAllAnimations];
    }
    
    if (anim == [self.bottomLeftHexagonLayer animationForKey:@"lastTopAppearenceAnimation"]) {
        [self.bottomLeftHexagonLayer removeAllAnimations];
        self.isAppearenceAnimationCompleted = YES;
    }
}

#pragma mark - Private
#pragma mark -

#pragma mark - Drawing

- (void)drawHexagonicalWireTop
{
    [self.hexagonicalTopLayer removeFromSuperlayer];
    
    self.hexagonicalTopLayer = [CAShapeLayer layer];
    self.hexagonicalTopLayer.frame = self.bounds;
    self.hexagonicalTopLayer.path =  [self hexagonsPathTop].CGPath;
    self.hexagonicalTopLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.hexagonicalTopLayer.fillColor = [UIColor clearColor].CGColor;
    self.hexagonicalTopLayer.position = CGPointMake(self.hexagonicalTopLayer.position.x - LeftOffset, self.hexagonicalTopLayer.position.y);
    self.layer.masksToBounds = YES;
    
    [self.layer insertSublayer:self.hexagonicalTopLayer above:self.notificationLayer];
}

- (void)drawHexagonicalWireBotton
{
    [self.bottomLeftHexagonLayer removeFromSuperlayer];
    self.bottomLeftHexagonLayer = [CAShapeLayer layer];
    [self prepareLayer:self.bottomLeftHexagonLayer onPosition:0];
    [self.layer insertSublayer:self.bottomLeftHexagonLayer atIndex:0];
    
    [self.bottomMidHexagonLayer removeFromSuperlayer];
    self.bottomMidHexagonLayer = [CAShapeLayer layer];
    [self prepareLayer:self.bottomMidHexagonLayer onPosition:1];
    [self.layer insertSublayer:self.bottomMidHexagonLayer atIndex:0];

    [self.bottomRightHexagonLayer removeFromSuperlayer];
    self.bottomRightHexagonLayer = [CAShapeLayer layer];
    [self prepareLayer:self.bottomRightHexagonLayer onPosition:3];
    [self.layer insertSublayer:self.bottomRightHexagonLayer above:self.notificationLayer];
    
    self.bottomLayerDefaultPosition = self.bottomLeftHexagonLayer.position;
}

- (void)prepareLayer:(CAShapeLayer *)shapeLayer onPosition:(NSUInteger)position
{
    shapeLayer.frame = self.bounds;
    if (position == 3) {
        shapeLayer.path =  [self pathForBottomRightHexagon].CGPath;
    } else {
        shapeLayer.path =  [self pathForBottomHexagonAtIndex:position].CGPath;
    }
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.position = CGPointMake(shapeLayer.position.x - LeftOffset, shapeLayer.position.y);
    self.layer.masksToBounds = YES;
}

- (void)updateAvatarPosition
{
    CGSize hexagonSize = [self hexagonOnWireSize];
    CGFloat originX = hexagonSize.width + (hexagonSize.width / 2 - LeftOffset) - self.avatarView.bounds.size.width / 2;
    self.leadingAvatarViewSpaceConstraint.constant = originX;
    self.avatarView.frame = CGRectMake(originX, self.avatarView.frame.origin.y, self.avatarView.frame.size.width, self.avatarView.frame.size.height);
}

- (void)prepareLogoImage
{
    [self prepareLogImageWithInitials];
    [self.avatarImageLayer removeFromSuperlayer];
    
    self.avatarImageLayer = [self layerWithImage:self.logoImage inRect:self.avatarView.bounds forMainLogo:YES];
    [self addHexagoneMaskForLayer:self.avatarImageLayer];
    
    self.borderLogoLayer = [CAShapeLayer layer];
    self.borderLogoLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLogoLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.borderLogoLayer.lineWidth = CornerWidthForAvatar;
    self.borderLogoLayer.frame = self.bounds;
    self.borderLogoLayer.path = [self prepareHexagonPathForRect:self.avatarView.bounds].CGPath;
    [self.avatarImageLayer addSublayer:self.borderLogoLayer];
    self.avatarView.layer.masksToBounds = YES;
    [self.avatarView.layer addSublayer:self.avatarImageLayer];
}

#pragma mark - BezierPath calculation

- (UIBezierPath *)prepareHexagonPathForRect:(CGRect)hexagonRect
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    
    [hexagonPath moveToPoint:CGPointMake(CGRectGetMidX(hexagonRect), 0)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMidX(hexagonRect), CGRectGetMaxY(hexagonRect))];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMidX(hexagonRect), 0)];
    
    return hexagonPath;
}

- (UIBezierPath *)hexagonsPathTop
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGSize hexagonSize = [self hexagonOnWireSize];
    [hexagonPath moveToPoint:CGPointMake(0, topOffset + hexagonSize.height * 0.25f)];
    
    for (int i = 0; i < ElementsInRowCount; i++) {
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.25f)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width * i, topOffset + hexagonSize.height * 0.25f)];
        
        [hexagonPath moveToPoint:CGPointMake(hexagonSize.width * (i + 1), topOffset + hexagonSize.height * 0.25f)];
    }
    return hexagonPath;
}

- (UIBezierPath *)pathForBottomRightHexagon
{
    UIBezierPath *resultPath = [UIBezierPath bezierPath];
    
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGSize hexagonSize = [self hexagonOnWireSize];
    [resultPath moveToPoint:CGPointMake(hexagonSize.width / 2, topOffset + hexagonSize.height * 0.25f + hexagonSize.height * 0.75f)];
    
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    for (int i = 3; i < ElementsInRowCount; i++) {
        UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
        [hexagonPath moveToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
        
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i + hexagonSize.width / 2, topOffset + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i + hexagonSize.width / 2, topOffset + hexagonSize.height * 0.5f + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset + hexagonSize.height * 0.5f + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
        
        [paths addObject:[hexagonPath bezierPathByReversingPath]];
    }
    for (UIBezierPath *invertedPath in [paths reversedArray]) {
        [resultPath appendPath:invertedPath];
    }
    return resultPath;
}

- (UIBezierPath *)pathForBottomHexagonAtIndex:(NSUInteger)i
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGSize hexagonSize = [self hexagonOnWireSize];
    
    [hexagonPath moveToPoint:CGPointMake(hexagonSize.width / 2, topOffset + hexagonSize.height * 0.25f + hexagonSize.height * 0.75f)];
    [hexagonPath moveToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
    
    [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i + hexagonSize.width / 2, topOffset + hexagonSize.height)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i + hexagonSize.width / 2, topOffset + hexagonSize.height * 0.5f + hexagonSize.height)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f + hexagonSize.height)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset + hexagonSize.height * 0.5f + hexagonSize.height)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset + hexagonSize.height)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
    
    return hexagonPath;
}

#pragma mark - FakeButtons Layers

- (void)prepareInformationButtonLayer
{
    [self.informationLayer removeFromSuperlayer];
    
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGRect placeHolderHexagonRect = CGRectMake(-LeftOffset, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    CGRect informationLayerRect = CGRectMake(hexagonSize.width * 6 - LeftOffset, topOffset, hexagonSize.width, hexagonSize.height);
    
    self.informationLayer = [self layerWithImage:self.informationButtonImage inRect:informationLayerRect forMainLogo:NO];
    [self addHexagoneMaskForLayer:self.informationLayer];

    [self.layer insertSublayer:self.informationLayer below:self.hexagonicalTopLayer];
}

- (void)prepareSearchButtonLayer
{
    [self.searchLayer removeFromSuperlayer];
    
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGRect placeHolderHexagonRect = CGRectMake(-LeftOffset, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    CGRect searchLayerRect = CGRectMake(hexagonSize.width * 7 - LeftOffset, topOffset, hexagonSize.width, hexagonSize.height);
    
    self.searchLayer = [self layerWithImage:self.searchButtonImage inRect:searchLayerRect forMainLogo:NO];
    [self addHexagoneMaskForLayer:self.searchLayer];

    [self.layer insertSublayer:self.searchLayer below:self.hexagonicalTopLayer];
}

- (void)prepareNotificationButtonLayer
{
    [self.notificationLayer removeFromSuperlayer];
    
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGRect placeHolderHexagonRect = CGRectMake(-LeftOffset, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    CGRect notificationLayerRect = CGRectMake(hexagonSize.width * 6 - LeftOffset + hexagonSize.width / 2, topOffset + hexagonSize.height * 0.75f, hexagonSize.width, hexagonSize.height);
    
//    UIImage *imageWithText = [self imageWithNotificationsInRect:notificationLayerRect];
    
    self.notificationLayer = [self layerWithImage:self.notificationButtonImage inRect:notificationLayerRect forMainLogo:NO];
    [self addHexagoneMaskForLayer:self.notificationLayer];
    
    [self.layer insertSublayer:self.notificationLayer below:self.hexagonicalTopLayer];
}

- (CALayer *)layerWithImage:(UIImage *)image inRect:(CGRect)rect forMainLogo:(BOOL)mainLogo
{
    CALayer *layer= [CALayer layer];
    layer.frame = rect;
    layer.backgroundColor = [DynamicUIService service].currentApplicationColor.CGColor;
    if (mainLogo) {
        layer.backgroundColor = [UIColor itemGradientTopColor].CGColor;
    }
    
    CGRect centerRect = CGRectMake(rect.size.width * 0.25, rect.size.height * 0.25, rect.size.width * 0.5, rect.size.height * 0.5);
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = centerRect;
    imageLayer.backgroundColor = [UIColor clearColor].CGColor;
    imageLayer.contents =(__bridge id __nullable)(image).CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    
    [layer addSublayer:imageLayer];
    layer.contentsGravity = kCAGravityResizeAspect;
    
    return layer;
}

- (void)addHexagoneMaskForLayer:(CALayer *)layer
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = layer.bounds;
    maskLayer.path = [self prepareHexagonPathForRect:layer.bounds].CGPath;
    layer.mask = maskLayer;
}

#pragma mark - Animations

- (CABasicAnimation *)animationPositionStart:(CGPoint) startPoint positionEnd:(CGPoint) endPoint
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:startPoint];
    animation.toValue = [NSValue valueWithCGPoint:endPoint];
    animation.duration = 0.3;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAAnimation *)layerPressAnimation
{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.6f];
    fadeAnimation.duration = 0.1f;
    fadeAnimation.autoreverses = YES;
    fadeAnimation.removedOnCompletion = YES;
    
    return fadeAnimation;
}

- (void)moveBottomLeftHexagonToTop:(BOOL)top
{
    CGSize hexagonSize = [self hexagonOnWireSize];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.bottomLeftHexagonLayer.position];
    if (top) {
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bottomLayerDefaultPosition.x - hexagonSize.width * 0.5f, self.bottomLayerDefaultPosition.y - hexagonSize.height * 0.75f)];
    } else {
        positionAnimation.toValue = [NSValue valueWithCGPoint:self.bottomLayerDefaultPosition];
    }
    positionAnimation.duration = 0.25f;
    [self.bottomLeftHexagonLayer addAnimation:positionAnimation forKey:nil];
    self.bottomLeftHexagonLayer.position = [positionAnimation.toValue CGPointValue];
}

- (void)moveLayer:(CAShapeLayer *)shapeLayer toTop:(BOOL)top
{
    CGSize hexagonSize = [self hexagonOnWireSize];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:shapeLayer.position];
    if (top) {
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bottomLayerDefaultPosition.x + hexagonSize.width * 0.5f, self.bottomLayerDefaultPosition.y - hexagonSize.height * 0.75f)];
    } else {
        positionAnimation.toValue = [NSValue valueWithCGPoint:self.bottomLayerDefaultPosition];
    }
    positionAnimation.duration = 0.25f;
    [shapeLayer addAnimation:positionAnimation forKey:nil];
    shapeLayer.position = [positionAnimation.toValue CGPointValue];
}

#pragma mark - Animations Related Calculations

- (BOOL)enebleAnimation:(BOOL)enable
{
    if (enable && (self.notificationLayer.position.y != self.informationLayer.position.y + self.informationLayer.bounds.size.height * 0.75f)) {
        return NO;
    }
    if (!enable && (self.informationLayer.position.y < self.notificationLayer.position.y)) {
        return NO;
    }
    return YES;
}

- (CGPoint)calculateEndPositionForNotificationLayerWithMInizizedLayout:(BOOL)minimized
{
    CGFloat startPositionX = self.notificationLayer.position.x;
    CGFloat deltaX = self.notificationLayer.bounds.size.width / 2.0f;
    
    CGFloat startPositionY = self.notificationLayer.position.y;
    CGFloat deltaY = self.notificationLayer.bounds.size.height * 0.75f;
    
    CGPoint position = CGPointMake(
                                   minimized ? startPositionX - deltaX : startPositionX + deltaX ,
                                   minimized ? startPositionY - deltaY : startPositionY + deltaY
                                   );
    return position;
}

- (CGPoint)calculateEndPositionForInformationLayerWithMInizizedLayout:(BOOL)minimized
{
    CGFloat startPositionX = self.informationLayer.position.x;
    CGFloat deltaX = self.informationLayer.bounds.size.width;
    CGFloat startPositionY = self.informationLayer.position.y;
    
    CGPoint position = CGPointMake( minimized ? startPositionX - deltaX : startPositionX + deltaX, startPositionY );
    return position;
}

- (CGSize)hexagonOnWireSize
{
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGRect placeHolderHexagonRect = CGRectMake(0, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    return hexagonSize;
}

#pragma mark - DrawText for Notification


- (UIImage *)imageWithNotificationsInRect:(CGRect)rect
{
    NSString *textToDraw = [NSString stringWithFormat:@"%i", (int)self.notificationsCount];
    CGSize textSize = [textToDraw sizeWithAttributes:[self textAttributes]];
    
    if (!self.notificationsCount) {
        textToDraw = @"";
    }

    UIImage *imageWithText = [self.notificationButtonImage drawText:textToDraw atPoint:CGPointMake(self.notificationButtonImage.size.width / 2, self.notificationButtonImage.size.height / 2 - textSize.height / 2)  withAttributes:[self textAttributes] inRect:rect];
    
    return imageWithText;
}

- (void)prepareLogImageWithInitials
{
    if (!self.logoImage && self.userInitials.length) {
        UIImage *logoImage = [UIImage imageWithColor:[UIColor grayColor] inRect:self.avatarView.bounds];
        CGSize textSize = [self.userInitials sizeWithAttributes:[self textAttributes]];
        self.logoImage = [logoImage drawText:self.userInitials atPoint:CGPointMake(logoImage.size.width / 2 - textSize.width / 2, logoImage.size.height / 2 - textSize.height / 2) withAttributes:[self textAttributes]];
    }
}

- (NSDictionary *)textAttributes
{
    return @{
             NSFontAttributeName : [UIFont boldSystemFontOfSize:24.f],
             NSForegroundColorAttributeName : [UIColor whiteColor]
             };
}

#pragma mark - Constraints

- (void)addConstraintsForView:(UIView *)view
{
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:0]
                           ]];
}

@end