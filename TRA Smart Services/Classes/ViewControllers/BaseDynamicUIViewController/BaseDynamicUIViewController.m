//
//  BaseDynamicUIViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 01.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]
#define setMustOverride() NSLog(@"%@ - method not implemented", NSStringFromClass([self class])); mustOverride()

#import "BaseDynamicUIViewController.h"

@implementation BaseDynamicUIViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dynamicService = [DynamicUIService service];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRTLArabicUI) name:UIDynamicServiceNotificationKeyNeedSetRTLUI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLTREuropeUI) name:UIDynamicServiceNotificationKeyNeedSetLTRUI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsUpdateFont) name:UIDynamicServiceNotificationKeyNeedUpdateFont object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsUpdateFontWithSize) name:UIDynamicServiceNotificationKeyNeedUpdateFontWithSize object:nil];
    
    if (self.dynamicService.language == LanguageTypeArabic) {
        [self setRTLArabicUI];
    } else {
        [self setLTREuropeUI];
    }
    if (self.dynamicService.fontWasChanged) {
        [self setNeedsUpdateFontWithSize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self localizeUI];
    [self updateColors];
    [self setNeedsUpdateFont];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Pubic

- (void)updateSubviewForParentViewIfPossible:(UIView *)mainView fontSizeInclude:(BOOL)includeFontSizeChange
{
    NSArray *subViews = mainView.subviews;
    if (subViews.count) {
        for (UIView * subView in subViews) {
            
            if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UILabel class]] || [subView isKindOfClass:[UIButton class]] ) {
                    if (includeFontSizeChange) {
                        [self updateFontSizeForView:subView];
                    } else {
                        [self updateFontForView:subView];
                    }
            }
            [self updateSubviewForParentViewIfPossible:subView fontSizeInclude:includeFontSizeChange];
        }
    }
}

- (void)localizeUI
{
    setMustOverride();
    //dummy
}

- (void)updateColors
{
    setMustOverride();
    //dummy
}

- (void)setRTLArabicUI
{
    //dummy
}

- (void)setLTREuropeUI
{
    //dummy
}

#pragma mark - Private Notifications

- (void)setNeedsUpdateFont
{
    [self updateSubviewForParentViewIfPossible:self.view fontSizeInclude:NO];
}

- (void)setNeedsUpdateFontWithSize
{
    [self updateSubviewForParentViewIfPossible:self.view fontSizeInclude:YES];
}

#pragma mark - Private

- (void)updateFontSizeForView:(UIView *)view
{
    if ([view respondsToSelector:@selector(setFont:)] && view.tag != DeclineTagForFontUpdate) {
        CGFloat smallMultiplier = -1.5;
        CGFloat normalMultiplier = +1.5;
        CGFloat currentFontSize = ((UIFont *)[view valueForKey:@"font"]).pointSize;
        
        ApplicationFont prevFontSize = [[[NSUserDefaults standardUserDefaults] valueForKey:PreviousFontSizeKey] integerValue];
        
        CGFloat fontSize = currentFontSize;
        if (prevFontSize == ApplicationFontBig && [DynamicUIService service].fontSize == ApplicationFontUndefined) {
            fontSize = currentFontSize + smallMultiplier;
        } else if (prevFontSize == ApplicationFontUndefined && [DynamicUIService service].fontSize == ApplicationFontSmall) {
            fontSize = currentFontSize + smallMultiplier;
        } else if (prevFontSize == ApplicationFontSmall && [DynamicUIService service].fontSize == ApplicationFontUndefined) {
            fontSize = currentFontSize + normalMultiplier;
        } else if (prevFontSize == ApplicationFontUndefined && [DynamicUIService service].fontSize == ApplicationFontBig) {
            fontSize = currentFontSize + normalMultiplier;
        } else if (prevFontSize == ApplicationFontSmall && [DynamicUIService service].fontSize == ApplicationFontBig) {
            fontSize = currentFontSize + 2 * normalMultiplier;
        } else if (prevFontSize == ApplicationFontBig && [DynamicUIService service].fontSize == ApplicationFontSmall) {
            fontSize = currentFontSize + 2 * smallMultiplier;
        }
        NSString *fontName = ((UIFont *)[view valueForKey:@"font"]).fontName;
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        
        if ([DynamicUIService service].language == LanguageTypeArabic) {
            if (![font.fontName containsString:DroidFontPrefix]) {
                font = [UIFont droidKufiRegularFontForSize:fontSize];
            }
        } else {
            if (![font.fontName containsString:LatoFontPrefix]) {
                font = [UIFont latoRegularWithSize:fontSize];
            }
        }
        [view setValue:font forKey:@"font"];
    }
}

- (void)updateFontForView:(UIView *)view
{
    if ([view respondsToSelector:@selector(setFont:)] && view.tag != DeclineTagForFontUpdate) {
        CGFloat currentFontSize = ((UIFont *)[view valueForKey:@"font"]).pointSize;
        UIFont *font = (UIFont *)[view valueForKey:@"font"];
        
        if ([DynamicUIService service].language == LanguageTypeArabic) {
            if (![font.fontName containsString:DroidFontPrefix]) {
                font = [UIFont droidKufiRegularFontForSize:currentFontSize];
            }
        } else {
            if (![font.fontName containsString:LatoFontPrefix]) {
                font = [UIFont latoRegularWithSize:currentFontSize];
            }
        }
        [view setValue:font forKey:@"font"];
    }
}

@end