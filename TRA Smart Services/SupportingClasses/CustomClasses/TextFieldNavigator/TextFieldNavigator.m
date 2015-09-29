//
//  TextFieldNavigator.m
//  
//
//  Created by Admin on 1/14/15.
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
