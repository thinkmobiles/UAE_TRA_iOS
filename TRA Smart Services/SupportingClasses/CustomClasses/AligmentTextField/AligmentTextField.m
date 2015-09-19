//
//  AligmentTextField.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 19.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "AligmentTextField.h"

@implementation AligmentTextField

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareAppearence];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareAppearence];
    }
    return self;
}

#pragma mark - Private

- (void)prepareAppearence
{
    NSTextAlignment textAlignment = [DynamicUIService service].language == LanguageTypeArabic ? NSTextAlignmentRight : NSTextAlignmentLeft;
    [[AligmentTextField appearance] setTextAlignment:textAlignment];
}

@end
