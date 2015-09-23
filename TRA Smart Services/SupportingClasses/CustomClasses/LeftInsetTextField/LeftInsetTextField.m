//
//  LeftInsetTextField.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 02.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "LeftInsetTextField.h"

@implementation LeftInsetTextField

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if (!self.insetValue) {
            self.insetValue = 0;
        }
    }
    return self;
}

#pragma mark - Override

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, self.insetValue, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, self.insetValue, 0);
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
