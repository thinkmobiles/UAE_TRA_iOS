//
//  BaseXibView.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 09.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseXibView.h"

@implementation BaseXibView

#pragma mark - Public

- (instancetype)initWithCoder:(NSCoder *)coder nibName:(NSString *)nibName
{
    self = [super initWithCoder:coder];
    if (self) {
        NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        UIView *view = [nibsArray firstObject];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self addConstraintsForView:view];
    }
    return self;
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
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:view
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:0]
                           ]];
}


@end
