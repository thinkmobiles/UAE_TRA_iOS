//
//  DynamicLanguageService.h
//  testOnFlyLocalizationStrings
//
//  Created by Kirill Gorbushko on 16.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

#define dynamicLocalizedString(key) [[DynamicUIService service] localizableStringForKey:(key)]

typedef NS_ENUM(NSUInteger, LanguageType) {
    LanguageTypeDefault,
    LanguageTypeEnglish,
    LanguageTypeArabic,
    LanguageTypeFrench,
};

typedef NS_ENUM(NSUInteger, ApplicationFont) {
    ApplicationFontUndefined = 12,
    ApplicationFontSmall = 12,
    ApplicationFontBig = 24
};

@interface DynamicUIService : NSObject

+ (instancetype)service;
- (void)setLanguage:(LanguageType)language;
- (NSString *)localizableStringForKey:(NSString *)key;

@property (assign, nonatomic) ApplicationFont fontSize;

@end
