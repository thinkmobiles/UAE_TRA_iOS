//
//  NSString+Validation.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 28.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

@interface NSString (Validation)

- (BOOL)isValidUserName;
- (BOOL)isValidURL;
- (BOOL)isValidIDEmirates;
- (BOOL)isValidName;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidEmailUseHardFilter:(BOOL)filter;

@end
