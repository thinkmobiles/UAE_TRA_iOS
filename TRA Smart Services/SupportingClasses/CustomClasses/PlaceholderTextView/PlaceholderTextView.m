//
//  UIPlaceholderTextView.m
//  PlaceholderTextView
//
//  Created by Roma on 07.09.15.
//  Copyright (c) 2015 Roma. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()

@property (strong, nonatomic) UILabel *placeHolderLabel;

@end

@implementation PlaceholderTextView

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!self.placeholder.length) {
        self.placeholder = @"";
    }
    if (!self.placeholderColor) {
        self.placeholderColor = [UIColor lightGrayColor];
    }
    [self insetContentText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Accessors

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textChanged:nil];
}

#pragma mark - Notification

- (void)textChanged:(NSNotification *)notification
{
    if(!self.placeholder.length) {
        return;
    }
    if(!self.text.length) {
        [self.placeHolderLabel setHidden:NO];
    } else {
        [self.placeHolderLabel setHidden:YES];
    }
}

#pragma mark - Overwriten

- (void)drawRect:(CGRect)rect
{
    if( self.placeholder.length ) {
        [self.placeHolderLabel removeFromSuperview];
        self.placeHolderLabel = nil;
        
        [self setupPlaceHolderLabel];
        if (!self.text.length) {
            [self.placeHolderLabel setHidden:NO];
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

- (void)setupPlaceHolderLabel
{
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.insetValue + 5,8,self.bounds.size.width - 2 * (self.insetValue + 5), self.font.lineHeight)];
    self.placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.font = self.font;
    self.placeHolderLabel.textAlignment = self.textAlignment;
    self.placeHolderLabel.backgroundColor = [UIColor clearColor];
    self.placeHolderLabel.textColor = self.placeholderColor;
    [self addSubview:self.placeHolderLabel];
    self.placeHolderLabel.text = self.placeholder;
    [self sendSubviewToBack:self.placeHolderLabel];
}

@end