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
@property (strong, nonatomic) CAShapeLayer *hexagonicalBottonLayer;
@property (strong, nonatomic) CALayer *imageLayer;

@property (strong, nonatomic) CALayer *informationLayer;
@property (strong, nonatomic) CALayer *searchLayer;
@property (strong, nonatomic) CALayer *notificationLayer;

@property (assign, nonatomic) BOOL disableFakeButtonLayersDrawing;

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
            if (layer == self.imageLayer) {
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
    self.hexagonicalBottonLayer.opacity = 1 - opacityLevel;
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
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:self.imageLayer.transform];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:transformation];
    scaleAnimation.duration = 0.25;
    [self.imageLayer addAnimation:scaleAnimation forKey:nil];
    self.imageLayer.transform = transformation;
}

- (void)scaleLogoFor:(CGFloat)scale
{
    CATransform3D transformation = CATransform3DIdentity;
    transformation = CATransform3DScale(transformation, scale, scale, 1);
    self.imageLayer.transform = transformation;
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
}

#pragma mark - Private
#pragma mark -

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
    [self.hexagonicalBottonLayer removeFromSuperlayer];
    
    self.hexagonicalBottonLayer = [CAShapeLayer layer];
    self.hexagonicalBottonLayer.frame = self.bounds;
    self.hexagonicalBottonLayer.path =  [self hexagonsPathBotton].CGPath;
    self.hexagonicalBottonLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.hexagonicalBottonLayer.fillColor = [UIColor clearColor].CGColor;
    self.hexagonicalBottonLayer.position = CGPointMake(self.hexagonicalBottonLayer.position.x - LeftOffset, self.hexagonicalBottonLayer.position.y);
    self.layer.masksToBounds = YES;

    [self.layer insertSublayer:self.hexagonicalBottonLayer atIndex:0];
}

- (UIBezierPath *)hexagonsPathTop
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];

    CGFloat topOffset = self.bounds.size.height * 0.12f;
    
    CGRect placeHolderHexagonRect = CGRectMake(0, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    
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

- (UIBezierPath *)hexagonsPathBotton;
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    
    CGRect placeHolderHexagonRect = CGRectMake(0, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    
    [hexagonPath moveToPoint:CGPointMake(hexagonSize.width / 2, topOffset + hexagonSize.height * 0.25f + hexagonSize.height * 0.75f)];
    
    for (int i = 0; i < ElementsInRowCount; i++) {
        if (i == 2) {
            continue;
        }
        [hexagonPath moveToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
        
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i + hexagonSize.width / 2, topOffset + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i + hexagonSize.width / 2, topOffset + hexagonSize.height * 0.5f + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width + hexagonSize.width * i, topOffset + hexagonSize.height * 0.75f + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset + hexagonSize.height * 0.5f + hexagonSize.height)];
        [hexagonPath addLineToPoint:CGPointMake(hexagonSize.width / 2 + hexagonSize.width * i, topOffset + hexagonSize.height)];
    }
    return hexagonPath;
}

- (void)updateAvatarPosition
{
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGRect placeHolderHexagonRect = CGRectMake(0, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    
    CGFloat originX = hexagonSize.width + (hexagonSize.width / 2 - LeftOffset) - self.avatarView.bounds.size.width / 2;
    self.leadingAvatarViewSpaceConstraint.constant = originX;
    self.avatarView.frame = CGRectMake(originX, self.avatarView.frame.origin.y, self.avatarView.frame.size.width, self.avatarView.frame.size.height);
}

- (void)prepareLogoImage
{
    [self prepareLogImageWithInitials];
    
    [self.imageLayer removeFromSuperlayer];

    self.imageLayer = [self layerWithImage:self.logoImage inRect:self.avatarView.bounds forMainLogo:YES];
    [self addHexagoneMaskForLayer:self.imageLayer];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = CornerWidthForAvatar;
    borderLayer.frame = self.bounds;
    borderLayer.path = [self prepareHexagonPathForRect:self.avatarView.bounds].CGPath;
    [self.imageLayer addSublayer:borderLayer];
    
    self.avatarView.layer.masksToBounds = YES;
    [self.avatarView.layer addSublayer:self.imageLayer];
}

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
    layer.backgroundColor = [UIColor defaultOrangeColor].CGColor;
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

@end