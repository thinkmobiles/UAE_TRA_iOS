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
@property (weak, nonatomic) IBOutlet UIView *avatarView;

@property (strong, nonatomic) CAShapeLayer *hexagonicalLayer;
@property (strong, nonatomic) CALayer *imageLayer;

@property (strong, nonatomic) CALayer *informationLayer;
@property (strong, nonatomic) CALayer *searchLayer;
@property (strong, nonatomic) CALayer *notificationLayer;

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
    
    [self drawHexagonicalWire];
    [self updateAvatarPosition];
    [self prepareLogoImage];
    
    [self prepareInformationButtonLayer];
    [self prepareSearchButtonLayer];
    [self prepareNotificationButtonLayer];
}

#pragma mark - Override

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
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

#pragma mark - Private

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

- (void)drawHexagonicalWire
{
    [self.hexagonicalLayer removeFromSuperlayer];
    
    self.hexagonicalLayer = [CAShapeLayer layer];
    self.hexagonicalLayer.frame = self.bounds;
    self.hexagonicalLayer.path =  [self hexagonsPath].CGPath;
    self.hexagonicalLayer.strokeColor = [UIColor redColor].CGColor;
    self.hexagonicalLayer.fillColor = [UIColor clearColor].CGColor;
    self.hexagonicalLayer.position = CGPointMake(self.hexagonicalLayer.position.x - LeftOffset, self.hexagonicalLayer.position.y);
    self.layer.masksToBounds = YES;

    [self.layer insertSublayer:self.hexagonicalLayer atIndex:0];
}

- (UIBezierPath *)hexagonsPath
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
    
    CGFloat constraintSpace = hexagonSize.width + (hexagonSize.width / 2 - LeftOffset) - self.avatarView.bounds.size.width / 2;
    self.leadingAvatarViewSpaceConstraint.constant = constraintSpace;
}

- (void)prepareLogoImage
{
    [self prepareLogImageWithInitials];
    
    [self.imageLayer removeFromSuperlayer];

    self.imageLayer = [self layerWithImage:self.logoImage inRect:self.avatarView.bounds];
    [self addHexagoneMaskForLayer:self.imageLayer];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor yellowColor].CGColor;
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
    
    self.informationLayer = [self layerWithImage:self.informationButtonImage inRect:informationLayerRect];
    [self addHexagoneMaskForLayer:self.informationLayer];

    [self.layer insertSublayer:self.informationLayer below:self.hexagonicalLayer];
}

- (void)prepareSearchButtonLayer
{
    [self.searchLayer removeFromSuperlayer];
    
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGRect placeHolderHexagonRect = CGRectMake(-LeftOffset, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    CGRect searchLayerRect = CGRectMake(hexagonSize.width * 7 - LeftOffset, topOffset, hexagonSize.width, hexagonSize.height);
    
    self.searchLayer = [self layerWithImage:self.searchButtonImage inRect:searchLayerRect];
    [self addHexagoneMaskForLayer:self.searchLayer];

    [self.layer insertSublayer:self.searchLayer below:self.hexagonicalLayer];
}

- (void)prepareNotificationButtonLayer
{
    [self.notificationLayer removeFromSuperlayer];
    
    CGFloat topOffset = self.bounds.size.height * 0.12f;
    CGRect placeHolderHexagonRect = CGRectMake(-LeftOffset, topOffset, self.bounds.size.width, self.bounds.size.height);
    CGSize hexagonSize = CGSizeMake(placeHolderHexagonRect.size.width / ElementsInRowCount, placeHolderHexagonRect.size.height / ElementsColumsCount);
    CGRect notificationLayerRect = CGRectMake(hexagonSize.width * 6 - LeftOffset + hexagonSize.width / 2, topOffset + hexagonSize.height * 0.75f, hexagonSize.width, hexagonSize.height);
    
    UIImage *imageWithText = [self imageWithNotificationsInRect:notificationLayerRect];
    
    self.notificationLayer = [self layerWithImage:imageWithText inRect:notificationLayerRect];
    [self addHexagoneMaskForLayer:self.notificationLayer];
    
    [self.layer insertSublayer:self.notificationLayer below:self.hexagonicalLayer];
}

- (CALayer *)layerWithImage:(UIImage *)image inRect:(CGRect)rect
{
    CALayer *layer= [CALayer layer];
    layer.frame = rect;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.contents = (__bridge id __nullable)(image).CGImage;
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

#pragma mark - DrawText for Notification

- (UIImage *)imageWithNotificationsInRect:(CGRect)rect
{
    NSString *textToDraw = [NSString stringWithFormat:@"%i", (int)self.notificationsCount];
    CGSize textSize = [textToDraw sizeWithAttributes:[self textAttributes]];
    
    UIImage *imageWithText = [self.notificationButtonImage drawText:textToDraw atPoint:CGPointMake(self.notificationButtonImage.size.width / 2, self.notificationButtonImage.size.height / 2 - textSize.height / 2)  withAttributes:[self textAttributes]];
    
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