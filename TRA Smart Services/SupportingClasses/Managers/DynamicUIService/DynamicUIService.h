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
};

typedef NS_ENUM(NSUInteger, ApplicationFont) {
    ApplicationFontUndefined = 0,
    ApplicationFontSmall = 1,
    ApplicationFontBig = 2
};

typedef NS_ENUM(NSUInteger, ApplicationColor) {
    ApplicationColorDefault,
    ApplicationColorOrange,
    ApplicationColorBlue,
    ApplicationColorGreen,
    ApplicationColorBlackAndWhite
};

static NSString *const UIDynamicServiceNotificationKeyNeedSetRTLUI = @"UIDynamicServiceNotificationKeyNeedSetRTLUI";
static NSString *const UIDynamicServiceNotificationKeyNeedSetLTRUI = @"UIDynamicServiceNotificationKeyNeedSetLTRUI";
static NSString *const UIDynamicServiceNotificationKeyNeedUpdateFontWithSize = @"UIDynamicServiceNotificationKeyNeedUpdateFontWithSize";
static NSString *const UIDynamicServiceNotificationKeyNeedUpdateFont = @"UIDynamicServiceNotificationKeyNeedUpdateFont";

@interface DynamicUIService : NSObject

@property (assign, nonatomic) BOOL fontWasChanged;

@property (assign, nonatomic) ApplicationFont fontSize;
@property (assign, nonatomic) ApplicationColor colorScheme;
@property (assign, nonatomic) LanguageType language;

+ (instancetype)service;

- (void)setLanguage:(LanguageType)language;
- (void)saveCurrentFontSize:(ApplicationFont)fontSize;
- (void)saveCurrentColorScheme:(ApplicationColor)color;

- (UIColor *)currentApplicationColor;
- (NSString *)localizableStringForKey:(NSString *)key;

@end