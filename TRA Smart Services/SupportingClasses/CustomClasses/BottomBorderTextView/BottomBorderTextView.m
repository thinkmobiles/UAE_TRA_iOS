//
//  BottomBorderTextView.m
//  TRA Smart Services
//
//  Created by Admin on 9/25/15.
//

#import "BottomBorderTextView.h"

@interface BottomBorderTextView ()

@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation BottomBorderTextView

#pragma mark - LifeCycle

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self addBottomBorder:newSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self changeBorder];
}

#pragma mark - Accessor

- (void)setBottomBorderColor:(UIColor *)bottomBorderColor
{
    _bottomBorderColor = bottomBorderColor;
    _bottomBorder.backgroundColor = bottomBorderColor.CGColor;
}

- (void)changeBorder
{
    _bottomBorder.frame = CGRectMake(self.frame.origin.x, self.frame.size.height + self.frame.origin.y + 1, self.frame.size.width, 1.0f);
}

#pragma mark - Private

- (void)addBottomBorder:(UIView *)superView
{
    if (!_bottomBorder) {
        _bottomBorder = [CALayer layer];
    }
    [self changeBorder];
    _bottomBorder.backgroundColor = [UIColor clearColor].CGColor;
    [superView.layer addSublayer:_bottomBorder];
}

@end
