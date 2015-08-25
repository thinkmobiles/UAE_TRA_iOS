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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRTLArabicUI) name:UIDynamicServiceNotificationKeyNeedSetRTLUI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLTREuropeUI) name:UIDynamicServiceNotificationKeyNeedSetLTRUI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsUpdateFont) name:UIDynamicServiceNotificationKeyNeedUpdateFont object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsUpdateFontWithSize) name:UIDynamicServiceNotificationKeyNeedUpdateFontWithSize object:nil];
    
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        [self setRTLArabicUI];
    } else {
        [self setLTREuropeUI];
    }
    
    [self setNeedsUpdateFontWithSize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self localizeUI];
    [self updateColors];
    
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
    if ([view respondsToSelector:@selector(setFont:)]) {
        CGFloat smallMultiplier = 0.9f;
        CGFloat bigMultiplier = 1.1f;
        
        CGFloat currentFontSize = ((UIFont *)[view valueForKey:@"font"]).pointSize;
        
        if ([DynamicUIService service].fontSize) {
            CGFloat fontSize = [DynamicUIService service].fontSize == ApplicationFontSmall ? currentFontSize * smallMultiplier : currentFontSize * bigMultiplier;
            NSString *fontName = ((UIFont *)[view valueForKey:@"font"]).fontName;
            
            UIFont *font = [UIFont fontWithName:fontName size:fontSize];
            if ([DynamicUIService service].language == LanguageTypeArabic) {
                font = [UIFont droidKufiRegularFontForSize:fontSize];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [view setValue:font forKey:@"font"];
            });
        }
    }
}

- (void)updateFontForView:(UIView *)view
{
    if ([view respondsToSelector:@selector(setFont:)]) {
        CGFloat currentFontSize = ((UIFont *)[view valueForKey:@"font"]).pointSize;
        
        if ([DynamicUIService service].fontSize) {
            NSString *fontName = ((UIFont *)[view valueForKey:@"font"]).fontName;
            
            UIFont *font = [UIFont fontWithName:fontName size:currentFontSize];
            if ([DynamicUIService service].language == LanguageTypeArabic) {
                font = [UIFont droidKufiRegularFontForSize:currentFontSize];
            }
            
            [view setValue:font forKey:@"font"];
        }
    }
}


@end