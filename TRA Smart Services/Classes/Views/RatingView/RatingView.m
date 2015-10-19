//
//  RatingView.m
//  TRA Smart Services
//
//  Created by Admin on 9/2/15.
//

#import "RatingView.h"

@implementation RatingView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder nibName:NSStringFromClass([self class])];
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
