//
//  CAGradientRadialLayer.m
//  360cam
//
//  Created by Admin on 08.07.15.
//

#import "CAGradientRadialLayer.h"

@implementation CAGradientRadialLayer

#pragma mark - Ovverride

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(nonnull CGContextRef)ctx
{
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,.6f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
}

@end
