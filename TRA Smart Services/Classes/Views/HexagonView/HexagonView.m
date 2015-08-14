//
//  HexagonView.m
//  testPentagonCells
//
//  Created by Kirill Gorbushko on 30.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "HexagonView.h"

static CGFloat ShadowOffset = 2.f;

@interface HexagonView()

@property (strong, nonatomic) CAShapeLayer *polygonLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (assign, nonatomic) BOOL needToDrawFradient;
@property (strong, nonatomic) NSMutableArray *colorsForGradient;

@end

@implementation HexagonView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareColors];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self preparePolygonLayer];
    if (self.colorsForGradient.count) {
        [self setGradientWithTopColors:self.colorsForGradient];
    }
}

#pragma mark - Public

- (void)removeAllDrawings
{
    [self.gradientLayer removeFromSuperlayer];
    [self.polygonLayer removeFromSuperlayer];
    [self.colorsForGradient removeAllObjects];
}

- (void)setGradientWithTopColors:(NSArray *)colors
{
    if (!self.colorsForGradient.count) {
        self.colorsForGradient = [colors mutableCopy];
    }
    
    [self.gradientLayer removeFromSuperlayer];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = self.colorsForGradient;
    self.gradientLayer.startPoint = CGPointMake(0.5, 0.2);
    self.gradientLayer.endPoint = CGPointMake(0.5, 1);
    self.gradientLayer.frame = self.bounds;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.bounds;
    maskLayer.path = [self hexagonPathWithOffset:ShadowOffset].CGPath;
    
    self.gradientLayer.mask = maskLayer;
    [self.layer addSublayer:self.gradientLayer];
    
    [self prepareShadowWithLayer:self.polygonLayer];
}

#pragma mark - Private

- (void)prepareShadowWithLayer:(CAShapeLayer *)layer
{
    [layer setShadowPath:[self hexagonPathWithOffset:ShadowOffset].CGPath];
    [layer setShadowOffset:CGSizeMake(1, 1)];
    [layer setShadowRadius:ShadowOffset];
    [layer setShadowOpacity:0.2f];
}

- (void)preparePolygonLayer
{
    [self.polygonLayer removeFromSuperlayer];
    
    self.polygonLayer = [CAShapeLayer layer];
    self.polygonLayer.path = [self hexagonPathWithOffset:0].CGPath;
    self.polygonLayer.strokeColor = self.viewStrokeColor.CGColor;
    self.polygonLayer.fillColor = self.viewFillColor.CGColor;
    
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:self.polygonLayer];
}

- (UIBezierPath *)hexagonPathWithOffset:(CGFloat)offset
{
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    
    CGRect hexagonRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width - offset, self.bounds.size.height - offset);
    
    [hexagonPath moveToPoint:CGPointMake(CGRectGetMidX(hexagonRect), 0)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMaxX(hexagonRect), CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMidX(hexagonRect), CGRectGetMaxY(hexagonRect))];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.75)];
    [hexagonPath addLineToPoint:CGPointMake(0, CGRectGetMaxY(hexagonRect) * 0.25)];
    [hexagonPath addLineToPoint:CGPointMake(CGRectGetMidX(hexagonRect), 0)];

    return hexagonPath;
}

- (void)prepareColors
{
    if (!self.viewFillColor) {
        self.viewFillColor = [UIColor clearColor];
    }
    if (!self.viewStrokeColor) {
        self.viewStrokeColor = [UIColor clearColor];
    }
}

@end
