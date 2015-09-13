//
//  RoundSlider.m
//
//
//  Created by Kirill Gorbushko on 13.09.15.
//  Copyright (c) 2015 Kirill Gorbushko. All rights reserved.
//

#import "RoundSlider.h"

@implementation RoundSlider

#pragma mark - Overwrite

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    CGRect superRect = [super minimumValueImageRectForBounds:bounds];

    CGRect newPosition = CGRectMake(superRect.size.width * 2.5f, superRect.origin.y, superRect.size.width, superRect.size.height);
    return newPosition;
}

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds
{
    CGRect superRect = [super maximumValueImageRectForBounds:bounds];
    
    CGRect newPosition = CGRectMake(superRect.origin.x - superRect.size.width * 2.5f, superRect.origin.y, superRect.size.width, superRect.size.height);
    return newPosition;
}

@end
