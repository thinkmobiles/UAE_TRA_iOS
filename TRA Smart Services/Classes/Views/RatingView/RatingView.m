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
    self = [super initWithCoder:coder nibName:@"RatingView"];
    return self;
}

#pragma mark - Action

- (IBAction)setRating:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(ratingChanged:)]) {
        [_delegate ratingChanged:[sender tag]];
    }
}

@end
