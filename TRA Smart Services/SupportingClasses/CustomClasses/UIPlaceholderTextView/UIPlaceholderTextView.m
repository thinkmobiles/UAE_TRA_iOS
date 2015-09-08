//
//  UIPlaceholderTextView.m
//  PlaceholderTextView
//
//  Created by Roma on 07.09.15.
//  Copyright (c) 2015 Roma. All rights reserved.
//

#import "UIPlaceholderTextView.h"

@interface UIPlaceholderTextView ()

@property (strong, nonatomic) UILabel *placeHolderLabel;

@end

@implementation UIPlaceholderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (!self.placeholder) {
        self.placeholder = @"";
    }
    if (!self.placeholderColor) {
        self.placeholderColor = [UIColor lightGrayColor];
    }
    if (!self.insetValue) {
        self.insetValue = 0;
    }
    [self insetContentText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setupView
{
    self.tintColor = [UIColor lightGrayColor];
    self.textColor = [UIColor blackColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.placeholder = @"";
        self.placeholderColor = [UIColor lightGrayColor];
        self.insetValue = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if(!self.placeholder.length) {
        return;
    }
        if(!self.text.length) {
            [[self viewWithTag:999] setHidden:NO];
        } else {
            [[self viewWithTag:999] setHidden:YES];
        }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];

}

- (void)drawRect:(CGRect)rect
{
    if( self.placeholder.length ) {
        if (!self.placeHolderLabel) {
            self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.insetValue + 5,8,self.bounds.size.width - 21,0)];
            self.placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.font = self.font;
            self.placeHolderLabel.backgroundColor = [UIColor clearColor];
            self.placeHolderLabel.textColor = self.placeholderColor;
            self.placeHolderLabel.tag = 999;
            [self addSubview:self.placeHolderLabel];
        }
        self.placeHolderLabel.text = self.placeholder;
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
        if (!self.text.length) {
            [[self viewWithTag:999] setAlpha:1];
        }
    }
    [super drawRect:rect];
}

#pragma mark - Private

- (void)insetContentText
{
    UIEdgeInsets contentText = self.textContainerInset;
    contentText.left = self.insetValue;
    contentText.right = self.insetValue;
    self.textContainerInset = contentText;
}

@end