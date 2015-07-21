//
//  TextFieldNavigator.m
//  Consent
//
//  Created by Kirill on 1/14/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "TextFieldNavigator.h"

@implementation TextFieldNavigator

#pragma mark - Public

+ (void)findNextTextFieldFromCurrent:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
}

@end
