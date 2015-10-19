//
//  NSString+Validation.h
//  TRA Smart Services
//
//  Created by Admin on 28.08.15.
//

@interface NSString (Validation)

- (BOOL)isValidUserName;
- (BOOL)isValidURL;
- (BOOL)isValidIDEmirates;
- (BOOL)isValidStateCode;
- (BOOL)isValidName;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidRating;
- (BOOL)isValidEmailUseHardFilter:(BOOL)filter;
- (BOOL)isValidIMEI;

@end
