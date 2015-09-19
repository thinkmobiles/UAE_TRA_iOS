//
//  FavouriteViewController+DeleteAction.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 19.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "FavouriteViewController+DeleteAction.h"

@implementation FavouriteViewController (DeleteAction)

#pragma mark - Public

- (void)drawDeleteAreaOnTable:(UITableView *)tableView
{
    [self prepareArcLayerOnTable:tableView];
    
    CGFloat heightOfScreen = [UIScreen mainScreen].bounds.size.height;
    CGFloat heightOfBottomDeletePart = heightOfScreen * 0.165;
    CGFloat startY = heightOfScreen - heightOfBottomDeletePart - ((UITabBarController *)[AppHelper rootViewController]).tabBar.frame.size.height - [self headerHeight];
    CGFloat arcHeight = 35.f;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat arcRadius = arcHeight / 2 + (width * width)/ (8 * arcHeight);
    
    UIBezierPath *arcBezierPath = [UIBezierPath bezierPath];
    [arcBezierPath moveToPoint:CGPointMake(0, startY)];
    [arcBezierPath addArcWithCenter:CGPointMake(width / 2, startY + arcRadius - heightOfBottomDeletePart) radius:arcRadius startAngle:0 endAngle:180 clockwise:YES];
    
    [self applyMaskToArcLayerWithPath:arcBezierPath];
    
    self.contentFakeIconLayer = [CALayer layer];
    CGFloat contentHeight = 50.f;
    CGFloat contentWidth = 44.f;
    self.contentFakeIconLayer.backgroundColor = [self currentDeleteAreaColor].CGColor;
    CGRect contentLayerRect = CGRectMake(width / 2 - contentWidth / 2, startY - heightOfBottomDeletePart / 2 , contentWidth, contentHeight);
    self.contentFakeIconLayer.frame = contentLayerRect;
    
    CGRect centerRect = CGRectMake(contentLayerRect.size.width * 0.25, contentLayerRect.size.height * 0.25, contentLayerRect.size.width * 0.5, contentLayerRect.size.height * 0.5);
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = centerRect;
    imageLayer.backgroundColor = [UIColor clearColor].CGColor;
    imageLayer.contents =(__bridge id __nullable)([UIImage imageNamed:@"ic_remove_red"]).CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    
    [self.contentFakeIconLayer addSublayer:imageLayer];
    
    CAShapeLayer *hexMaskLayer = [CAShapeLayer layer];
    hexMaskLayer.frame = self.contentFakeIconLayer.bounds;
    hexMaskLayer.path = [AppHelper hexagonPathForRect:self.contentFakeIconLayer.bounds].CGPath;
    self.contentFakeIconLayer.mask = hexMaskLayer;
    
    [self addShadowForContentLayerInRect:contentLayerRect];
    
    [self.arcDeleteZoneLayer addSublayer:self.contentFakeIconLayer];
    [self.arcDeleteZoneLayer insertSublayer:self.shadowFakeIconLayer below:self.contentFakeIconLayer];
    [tableView.layer addSublayer:self.arcDeleteZoneLayer];
    
    [self animateDeleteZoneAppearence];
}

- (void)animateDeleteZoneAppearence
{
    CGPoint endPoint = self.arcDeleteZoneLayer.position;
    self.arcDeleteZoneLayer.position = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y + self.arcDeleteZoneLayer.bounds.size.height / 2);
    
    CABasicAnimation *positionAmimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAmimation.fromValue = [NSValue valueWithCGPoint:self.arcDeleteZoneLayer.position];
    positionAmimation.toValue = [NSValue valueWithCGPoint:endPoint];
    positionAmimation.duration = AnimationDuration / 2;
    
    CGPoint endPointForDeleteIcon = self.shadowFakeIconLayer.position;
    CGPoint startPoint = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y + self.arcDeleteZoneLayer.bounds.size.height);
    CGPoint midPoint = CGPointMake(endPointForDeleteIcon.x, endPointForDeleteIcon.y - 40); //40 offset
    
    self.shadowFakeIconLayer.position = startPoint;
    self.contentFakeIconLayer.position = startPoint;
    
    CAKeyframeAnimation * springAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    springAnim.values = @[
                          [NSValue valueWithCGPoint:startPoint],
                          [NSValue valueWithCGPoint:midPoint],
                          [NSValue valueWithCGPoint:endPointForDeleteIcon]
                          ];
    springAnim.duration = AnimationDuration;
    springAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.arcDeleteZoneLayer addAnimation:positionAmimation forKey:nil];
    [self.shadowFakeIconLayer addAnimation:springAnim forKey:nil];
    [self.contentFakeIconLayer addAnimation:springAnim forKey:nil];
    
    self.arcDeleteZoneLayer.position = endPoint;
    self.shadowFakeIconLayer.position = endPointForDeleteIcon;
    self.contentFakeIconLayer.position = endPointForDeleteIcon;
}

- (void)selectDeleteZone:(BOOL)select
{
    self.shadowFakeIconLayer.shadowOpacity = select ? 0.02f : 0.2f;
    self.contentFakeIconLayer.opacity = select ? 0.5 : 1.0;
    self.arcDeleteZoneLayer.backgroundColor = select ? [[self currentDeleteAreaColor] colorWithAlphaComponent:0.7f].CGColor : [[self currentDeleteAreaColor] colorWithAlphaComponent:0.3f].CGColor;
}

- (void)animateDeleteZoneDisapearing
{
    CGPoint startPoint = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y);
    CGPoint midPoint = CGPointMake(startPoint.x, startPoint.y + 10);
    CGPoint endPoint = CGPointMake(self.arcDeleteZoneLayer.position.x, self.arcDeleteZoneLayer.position.y + self.arcDeleteZoneLayer.frame.size.height / 2);
    
    CAKeyframeAnimation *disappearAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    disappearAnimation.values = @[
                                  [NSValue valueWithCGPoint:startPoint],
                                  [NSValue valueWithCGPoint:midPoint],
                                  [NSValue valueWithCGPoint:endPoint]
                                  ];
    disappearAnimation.duration = AnimationDuration / 2;
    disappearAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    disappearAnimation.delegate = self;
    disappearAnimation.removedOnCompletion = NO;
    [self.arcDeleteZoneLayer addAnimation:disappearAnimation forKey:@"disapearAnimation"];
    self.arcDeleteZoneLayer.opacity = 0.;
}

- (void)removeDeleteZone
{
    [self.arcDeleteZoneLayer removeFromSuperlayer];
}

#pragma mark - Drawings

- (UIColor *)currentDeleteAreaColor
{
    UIColor *deleteAreaColor = [[UIColor redColor] colorWithAlphaComponent:0.8f];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        deleteAreaColor = [[self.dynamicService currentApplicationColor] colorWithAlphaComponent:0.8f];
    }
    return deleteAreaColor;
}

- (void)prepareArcLayerOnTable:(UITableView *)tableView
{
    self.arcDeleteZoneLayer = [CALayer layer];
    self.arcDeleteZoneLayer.frame = tableView.bounds;
    self.arcDeleteZoneLayer.backgroundColor = [[self currentDeleteAreaColor] colorWithAlphaComponent:0.3f].CGColor;
    self.arcDeleteZoneLayer.masksToBounds = YES;
}

- (void)applyMaskToArcLayerWithPath:(UIBezierPath *)arcBezierPath
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.arcDeleteZoneLayer.bounds;
    maskLayer.path = arcBezierPath.CGPath;
    maskLayer.shouldRasterize = YES;
    maskLayer.rasterizationScale = [UIScreen mainScreen].scale * 2.;
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.arcDeleteZoneLayer.mask = maskLayer;
}

- (void)addShadowForContentLayerInRect:(CGRect)contentLayerRect
{
    CGFloat shadowOffset = 5.f;
    CGRect shadowRect = CGRectMake(contentLayerRect.origin.x - shadowOffset, contentLayerRect.origin.y - shadowOffset, contentLayerRect.size.width + shadowOffset * 2, contentLayerRect.size.height + shadowOffset * 2);
    self.shadowFakeIconLayer = [CALayer layer];
    self.shadowFakeIconLayer.frame = shadowRect;
    [self.shadowFakeIconLayer setShadowPath:[AppHelper hexagonPathForRect:self.shadowFakeIconLayer.bounds].CGPath];
    [self.shadowFakeIconLayer setShadowOffset:CGSizeMake(0, 0)];
    [self.shadowFakeIconLayer setShadowRadius:5.f];
    [self.shadowFakeIconLayer setShadowOpacity:0.2f];
}

@end
