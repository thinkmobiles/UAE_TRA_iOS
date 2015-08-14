//
//
//  Consent
//
//  Created by Kirill Gorbushko on 26.01.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OffsetTextField.h"

@implementation OffsetTextField

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (self.leftImageName.length) {
        UIImage *leftImage = [UIImage imageNamed:self.leftImageName];
        self.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:leftImage];
        imageView.tintColor = [UIColor lightGrayColor];
        self.leftView = imageView;//[[UIImageView alloc] initWithImage:leftImage];
    }
    self.minimumFontSize = 12.f;
}

#pragma mark - Public

- (void)setPlaceholderColor:(UIColor *)placholderColor withPlacholderText:(NSString *)text
{
    if ([self respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor blackColor];
        if (text.length) {
            self.placeholder = text;
        }
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
}

#pragma mark - Ovverided

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    [super leftViewRectForBounds:bounds];
    CGRect leftViewFrame = self.leftView.frame;
    NSInteger yPosition = self.frame.size.height / 2 - leftViewFrame.size.height / 2;
    CGRect leftBounds = CGRectMake(0 + self.leftViewOffcet, yPosition, leftViewFrame.size.width, leftViewFrame.size.height);
    return leftBounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    [super placeholderRectForBounds:bounds];
    return CGRectInset(bounds, self.leftViewOffcet * 2 + self.leftView.frame.size.width, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    [super textRectForBounds:bounds];
    return CGRectInset(bounds, self.leftViewOffcet * 2 + self.leftView.frame.size.width, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    [super editingRectForBounds:bounds];
    return CGRectInset(bounds, self.leftViewOffcet * 2 + self.leftView.frame.size.width, 0);
}

#pragma mark - UIKeyInput

- (void)deleteBackward
{
    [super deleteBackward];
    
    if (self.subDelegate && [self.subDelegate respondsToSelector:@selector(textFieldDidDelete:)]){
        [self.subDelegate textFieldDidDelete:self];
    }
}

@end
