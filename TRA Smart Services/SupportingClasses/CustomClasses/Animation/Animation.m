//
//  Animation.m
//  
//
//  Created by Kirill Gorbushko on 29.04.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

#import "Animation.h"

@implementation Animation

#pragma mark - Public

+ (CABasicAnimation *)fadeAnimFromValue:(CGFloat)fromValue to:(CGFloat)toValue delegate:(id)delegate
{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @(fromValue);
    fadeAnimation.toValue = @(toValue);
    fadeAnimation.duration = 0.3f;
    if (delegate) {
        fadeAnimation.removedOnCompletion = NO;
        fadeAnimation.delegate = delegate;
    } else {
        fadeAnimation.removedOnCompletion = YES;
    }
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return fadeAnimation;
}

@end