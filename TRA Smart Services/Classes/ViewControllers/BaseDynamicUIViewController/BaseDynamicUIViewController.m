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
    
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        [self setRTLArabicUI];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateSubviewForParentViewIfPossible:self.view];
    [self localizeUI];
    [self updateColors];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Pubic

- (void)updateSubviewForParentViewIfPossible:(UIView *)mainView
{
    NSArray *subViews = mainView.subviews;
    if (subViews.count) {
        for (UIView * subView in subViews) {
            if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UILabel class]] || [subView isKindOfClass:[UIButton class]]) {
                [self updateFontSizeForView:subView];
            }
            [self updateSubviewForParentViewIfPossible:subView];
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

#pragma mark - Private

- (void)updateFontSizeForView:(UIView *)view
{
    if (view.tag == 1001) {
        return;
    }
    
    if ([view respondsToSelector:@selector(setFont:)]) {
        NSUInteger fontSize = [DynamicUIService service].fontSize;
        NSString *fontName = ((UIFont *)[view valueForKey:@"font"]).fontName;
        UIFont *updatedFont = [UIFont fontWithName:fontName size:fontSize];
        [view setValue:updatedFont forKey:@"font"];
    }
}

@end
