//
//  UIImage+HexagoneImage.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 02.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "UIImage+HexagoneImage.h"

static NSInteger HexagonSideSize = 30;
static NSInteger HexagonQuantity = 10;

@implementation UIImage (HexagoneImage)

#pragma mark - Public

+ (UIImage *)randomHexagonImageInRect:(CGRect)imageRect
{
    UIGraphicsBeginImageContext(imageRect.size);
    for (int i = 0; i < HexagonQuantity; i++) {
        UIBezierPath *hexagonPath = [UIImage hexagonRandomPathInRect:imageRect];
        CGContextSaveGState(UIGraphicsGetCurrentContext()); {
            [hexagonPath addClip];
            [[UIColor orangeColor] setStroke];
            [hexagonPath stroke];
        } CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
    
    UIImage *imageWithHex = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageWithHex;
}

#pragma mark - Private

+ (UIBezierPath *)hexagonRandomPathInRect:(CGRect)parentRect
{
    NSInteger maxX = parentRect.size.width - HexagonSideSize;
    NSInteger maxY = parentRect.size.height - HexagonSideSize;
    
    CGRect hexagonRect = CGRectMake(rand() % maxX, rand() % maxY, HexagonSideSize, HexagonSideSize);
    
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

@end
