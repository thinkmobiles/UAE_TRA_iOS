//
//  RatingView.m
//  TRA Smart Services
//
//  Created by Anatoliy Dalekorey on 9/2/15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"RatingView" owner:self options:nil];
        UIView *view = [nibsArray firstObject];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self addConstraintsForView:view];
    }
    return self;
}

#pragma mark - Action

- (IBAction)setRating:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(ratingChanged:)]) {
        [_delegate ratingChanged:[sender tag]];
    }
}

#pragma mark - Constraints

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
