//
//  DynamicLanguageService.m
//  testOnFlyLocalizationStrings
//
//  Created by Kirill Gorbushko on 16.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "DynamicUIService.h"

static NSString *const KeyCurrentLanguage = @"KeyCurrentLanguage";
static NSString *const KeyAppleLanguage = @"AppleLanguages";

static NSString *const KeyLanguageDefault = @"en";

static NSString *const KeyLanguageEnglish = @"en";
static NSString *const KeyLanguageArabic = @"ar";
static NSString *const KeyLanguageFrench = @"fr";

@interface DynamicUIService()

@property (strong, nonatomic) NSBundle *localeBundle;

@end

@implementation DynamicUIService

#pragma mark - Public

+ (instancetype)service
{
    static DynamicUIService *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DynamicUIService alloc] init];
    });
    return sharedManager;
}

- (NSString *)localizableStringForKey:(NSString *)key
{
    return NSLocalizedStringFromTableInBundle(key, nil, self.localeBundle, nil);
}

- (void)setLanguage:(LanguageType)language
{
    NSString *languageCode;
    switch (language) {
        case LanguageTypeDefault:
        case LanguageTypeEnglish: {
            languageCode = KeyLanguageEnglish;
            break;
        }
        case LanguageTypeArabic: {
            languageCode = KeyLanguageArabic;
            break;
        }
        case LanguageTypeFrench: {
            languageCode = KeyLanguageFrench;
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@[languageCode] forKey:KeyAppleLanguage];
    [[NSUserDefaults standardUserDefaults] setValue:languageCode forKey:KeyCurrentLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setLocaleWithLanguage:languageCode];
}

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepareDefaultLocaleBundle];
        self.fontSize = ApplicationFontSmall;
    }
    return self;
}

#pragma mark - Private

- (void)prepareDefaultLocaleBundle
{
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:KeyAppleLanguage];
    
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:KeyCurrentLanguage];
    if (language.length) {
        [[NSUserDefaults standardUserDefaults] setObject:@[language] forKey:KeyAppleLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        language = [languages objectAtIndex:0];
    }

    [self setLocaleWithLanguage:language];
}

- (void)setLocaleWithLanguage:(NSString *)selectedLanguage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:selectedLanguage ofType:@"lproj"];
    if (path.length) {
        self.localeBundle = [NSBundle bundleWithPath:path];
    } else {
        self.localeBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:KeyLanguageDefault ofType:@"lproj"] ];
    }

}

@end
