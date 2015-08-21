//
//  DynamicLanguageService.m
//  testOnFlyLocalizationStrings
//
//  Created by Kirill Gorbushko on 16.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "DynamicUIService.h"

static NSString *const KeyCurrentLanguage = @"KeyCurrentLanguage";
static NSString *const AppKeyCurrentColor = @"AppKeyCurrentColor";
static NSString *const AppKeyCurrentFontSize = @"AppKeyCurrentFontSize";

static NSString *const KeyAppleLanguage = @"AppleLanguages";

static NSString *const KeyLanguageDefault = @"en";

static NSString *const KeyLanguageEnglish = @"en";
static NSString *const KeyLanguageArabic = @"ar";

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
    LanguageType prevType = _language;
    _language = language;
    
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
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@[languageCode] forKey:KeyAppleLanguage];
    [[NSUserDefaults standardUserDefaults] setValue:languageCode forKey:KeyCurrentLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setLocaleWithLanguage:languageCode];
    
    if (prevType != language ) {
        if (prevType == LanguageTypeArabic) {
            [AppHelper reverseTabBarItems];
            [[NSNotificationCenter defaultCenter] postNotificationName:UIDynamicServiceNotificationKeyNeedSetLTRUI object:nil];
        } else if (language == LanguageTypeArabic) {
            [AppHelper reverseTabBarItems];
            [[NSNotificationCenter defaultCenter] postNotificationName:UIDynamicServiceNotificationKeyNeedSetRTLUI object:nil];
        }
    }
}

- (void)setFontSize:(ApplicationFont)fontSize
{
    ApplicationFont prevFont = _fontSize;
    _fontSize = fontSize;
    
    if (_fontSize != prevFont && prevFont != ApplicationFontUndefined) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDynamicServiceNotificationKeyNeedUpdateFont object:nil];
    }
}

#pragma mark - ColorScheme

- (UIColor *)currentApplicationColor
{
    UIColor *color;
    switch (self.colorScheme) {
        case ApplicationColorDefault:
        case ApplicationColorOrange : {
            color = [UIColor defaultOrangeColor];
            break;
        }
        case ApplicationColorBlue: {
            color = [UIColor defaultBlueColor];
            break;
        }
        case ApplicationColorGreen: {
            color = [UIColor defaultGreenColor];
        }
    }
    return color;
}

- (void)saveCurrentColorScheme:(ApplicationColor)color
{
    self.colorScheme = color;
    
    [[NSUserDefaults standardUserDefaults] setValue:@(color) forKey:AppKeyCurrentColor];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - FontSize

- (void)saveCurrentFontSize:(ApplicationFont)fontSize
{
    self.fontSize = fontSize;
    
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:AppKeyCurrentFontSize];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepareDefaultLocaleBundle];
        self.fontSize = [self currentApplicationFontSize];
        self.colorScheme = [self savedApplicationColor];
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

    [self updateCurrentLanguageWithName:language];
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

- (void)updateCurrentLanguageWithName:(NSString *)languageName
{
    if ([languageName isEqualToString:KeyLanguageEnglish]) {
        _language = LanguageTypeEnglish;
    } else if ([languageName isEqualToString:KeyLanguageArabic]) {
        _language = LanguageTypeArabic;
    }
}

#pragma mark - Color

- (ApplicationColor)savedApplicationColor
{
    ApplicationColor savedColor = ApplicationColorDefault;
    NSUInteger currentColor = [[[NSUserDefaults standardUserDefaults] valueForKey:AppKeyCurrentColor] integerValue];
    switch (currentColor) {
        case 1: {
            savedColor = ApplicationColorOrange;
            break;
        }
        case 2: {
            savedColor = ApplicationColorBlue;
            break;
        }
        case 3: {
            savedColor = ApplicationColorGreen;
            break;
        }
    }
    return savedColor;
}

#pragma mark - FontSize

- (ApplicationFont)currentApplicationFontSize
{
    ApplicationFont savedFont = ApplicationFontSmall;
    NSUInteger fontSize = [[[NSUserDefaults standardUserDefaults] valueForKey:AppKeyCurrentFontSize] integerValue];
    if (fontSize) {
        if (fontSize == ApplicationFontBig) {
            savedFont = ApplicationFontBig;
        }
    }
    return savedFont;
}

@end