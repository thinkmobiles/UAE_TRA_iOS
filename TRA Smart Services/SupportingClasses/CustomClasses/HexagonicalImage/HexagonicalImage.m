//
//  HexagonicalImage.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 02.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "HexagonicalImage.h"

static NSInteger HexagonSideSize = 30;
static NSInteger HexagonQuantity = 10;

@interface HexagonicalImage ()

@property (strong, nonatomic) NSMutableArray *drawedRects;
@property (strong, nonatomic) UIColor *rectColor;

@end

@implementation HexagonicalImage

#pragma mark - LifeCycle

- (instancetype)initWithRectColor:(UIColor *)rectColor
{
    self = [super init];
    if (self) {
        self.rectColor = rectColor;
    }
    return self;
}

#pragma mark - Public

- (UIImage *)randomHexagonImageInRect:(CGRect)imageRect
{
    [self cleanUp];
    
    UIGraphicsBeginImageContext(imageRect.size);
    for (int i = 0; i < HexagonQuantity; i++) {
        UIBezierPath *hexagonPath = [self hexagonRandomPathInRect:imageRect];
        CGContextSaveGState(UIGraphicsGetCurrentContext()); {
            [hexagonPath addClip];
            [self.rectColor setStroke];
            [hexagonPath stroke];
        } CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
    
    UIImage *imageWithHex = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageWithHex;
}

#pragma mark - Private

- (UIBezierPath *)hexagonRandomPathInRect:(CGRect)parentRect
{
    CGRect hexagonRect = [self rectForHexagonInParentRect:parentRect];
    while (CGRectIsEmpty(hexagonRect)) {
        hexagonRect = [self rectForHexagonInParentRect:parentRect];
    }
    
    UIBezierPath *hexagonPath = [UIBezierPath bezierPath];
    [hexagonPath moveToPoint:CGPointMake(hexagonRect.size.width / 2 + hexagonRect.origin.x, hexagonRect.origin.y)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonRect.size.width + hexagonRect.origin.x, hexagonRect.size.height * 0.25 + hexagonRect.origin.y)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonRect.size.width + hexagonRect.origin.x, hexagonRect.size.height  * 0.75 + hexagonRect.origin.y)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonRect.size.width / 2 + hexagonRect.origin.x, hexagonRect.size.height + hexagonRect.origin.y )];
    [hexagonPath addLineToPoint:CGPointMake(hexagonRect.origin.x,hexagonRect.size.height  * 0.75 + hexagonRect.origin.y)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonRect.origin.x, hexagonRect.size.height * 0.25 + hexagonRect.origin.y)];
    [hexagonPath addLineToPoint:CGPointMake(hexagonRect.size.width / 2 + hexagonRect.origin.x, hexagonRect.origin.y)];
    
    
    return hexagonPath;
}

- (CGRect)rectForHexagonInParentRect:(CGRect)parentRect
{
    u_int32_t maxX = parentRect.size.width - HexagonSideSize;
    u_int32_t maxY = parentRect.size.height - HexagonSideSize;
    
    CGRect hexagonRect = CGRectMake(arc4random_uniform(maxX), arc4random_uniform(maxY), HexagonSideSize, HexagonSideSize);
    
    for (NSValue *drawedRect in self.drawedRects) {
        CGRect inspectedRect = drawedRect.CGRectValue;
        if (CGRectIntersectsRect(inspectedRect, hexagonRect)) {
            return CGRectZero;
        }
    }
    
    [self.drawedRects addObject:[NSValue valueWithCGRect:hexagonRect]];
    return hexagonRect;
}

- (void)cleanUp
{
    self.drawedRects = [[NSMutableArray alloc] init];
}

@end
