//
//  DynamicLanguageService.h
//  testOnFlyLocalizationStrings
//
//  Created by Admin on 16.07.15.
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
    ApplicationColorDefault = 0,
    ApplicationColorOrange = 1,
    ApplicationColorBlue = 2,
    ApplicationColorGreen = 3,
    ApplicationColorBlackAndWhite = 4
};

static NSString *const UIDynamicServiceNotificationKeyNeedSetRTLUI = @"UIDynamicServiceNotificationKeyNeedSetRTLUI";
static NSString *const UIDynamicServiceNotificationKeyNeedSetLTRUI = @"UIDynamicServiceNotificationKeyNeedSetLTRUI";
static NSString *const UIDynamicServiceNotificationKeyNeedUpdateFontWithSize = @"UIDynamicServiceNotificationKeyNeedUpdateFontWithSize";
static NSString *const UIDynamicServiceNotificationKeyNeedUpdateFont = @"UIDynamicServiceNotificationKeyNeedUpdateFont";

@interface DynamicUIService : NSObject

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