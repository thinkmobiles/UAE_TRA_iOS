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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addBottomBorder];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addBottomBorder];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
}

#pragma mark - Accessor

- (void)setBottomBorderColor:(UIColor *)bottomBorderColor
{
    _bottomBorderColor = bottomBorderColor;
    _bottomBorder.backgroundColor = bottomBorderColor.CGColor;
}

#pragma mark - Private

- (void)addBottomBorder
{
    _bottomBorder = [CALayer layer];
    _bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    _bottomBorder.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_bottomBorder];
}

@end
