//
//  NSString+Validation.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 28.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidEmailUseHardFilter:(BOOL)filter
{
    BOOL stricterFilter = filter;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@{1}([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber
{
    NSString *allowedSymbols = @"[0-9]{4,}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

- (BOOL)isValidName
{
    NSString *allowedSymbols = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

- (BOOL)isValidURL
{
    NSString *allowedSymbols = @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

- (BOOL)isValidUserName
{
    NSString *allowedSymbols = @"[A-Za-z0-9-]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

- (BOOL)isValidIDEmirates
{
    NSString *allowedSymbols = @"[0-9]{3}[-]{1}[0-9]{4}[-]{1}[0-9]{7}[-]{1}[0-9]{1}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

- (BOOL)isValidStateCode
{
    NSString *allowedSymbols = @"[0-9]{1}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

- (BOOL)isValidRating
{
    NSString *allowedSymbols = @"[0-5]{1}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

- (BOOL)textIsValidPasswordFormat
{
    NSString *stricterFilterString = @"(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{8,10})$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    if (self.length < 6) {
        return NO;
    }
    else {
        return [passwordTest evaluateWithObject:self];
    }
}

@end
