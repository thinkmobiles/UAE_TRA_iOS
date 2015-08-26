//
//  MBProgressHUD+CancelButton.m
//  360cam
//
//  Created by Kirill Gorbushko on 06.07.15.
//  Copyright © 2015 Kirill Gorbushko. All rights reserved.
//

#import "MBProgressHUD+CancelButton.h"
#import <Foundation/Foundation.h>
#import "CAGradientRadialLayer.h"

static NSString *const CancelButtonTitle = @"X";

@implementation MBProgressHUD (CancelButton)

- (void)addCancelButtonForTarger:(id)target andSelector:(NSString *)selector;
{
    [self addGradientSublayer];
    
    CGRect frame = self.bounds;
    CGFloat buttonWidth = frame.size.width / 4;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    [button setImage:[UIImage imageNamed:@"ic_close_small"] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.backgroundColor = [UIColor clearColor];
    [button setTintColor:self.activityIndicatorColor];
    
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.f]]; //default kLabelFontSize = 16.f
    
    button.layer.cornerRadius = self.cornerRadius;
    button.layer.borderColor = self.layer.borderColor;
    button.layer.borderWidth = self.layer.borderWidth;
    
    [button addTarget:target action:NSSelectorFromString(selector) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:button
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:10.f],
                           [NSLayoutConstraint constraintWithItem:button
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:10.f],
                           [NSLayoutConstraint constraintWithItem:button
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.1f
                                                         constant:0.0],
                           [NSLayoutConstraint constraintWithItem:button
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.1f
                                                         constant:0.0]
                            ]
     ];
}

#pragma mark - Private

- (void)addGradientSublayer
{
    CAGradientRadialLayer *gradientLayer = [CAGradientRadialLayer new];
    gradientLayer.frame = self.bounds;
    
    [self.layer addSublayer:gradientLayer];
}

@end