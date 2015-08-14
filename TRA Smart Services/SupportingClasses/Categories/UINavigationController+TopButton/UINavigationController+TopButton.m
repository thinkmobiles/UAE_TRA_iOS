//
//  UINavigationController+RightButton.m
//  
//
//  Created by Kirill Gorbushko on 25.06.15.
//
//

#import "UINavigationController+TopButton.h"

static CGFloat const DefaultButtonWidth = 20;

@implementation UINavigationController (TopButton)

#pragma mark - Public

- (void)setButtonWithImageNamed:(NSString *)image andActionDelegate:(id)delegate tintColor:(UIColor *)tintColor position:(ButtonPositionMode)position selector:(SEL)buttonSelector;
{
    CGSize navBarSize = self.navigationBar.frame.size;
    CGRect buttonRect = CGRectMake(0, 0, DefaultButtonWidth,  navBarSize.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *imageToShow = [UIImage imageNamed:image];
    if (tintColor) {
        imageToShow = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setTintColor:tintColor];
    }
    [button setImage:imageToShow forState:UIControlStateNormal];
    [button addTarget:delegate action:buttonSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonForNav = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (position) {
        self.topViewController.navigationItem.rightBarButtonItem = buttonForNav;
    } else {
        self.topViewController.navigationItem.leftBarButtonItem = buttonForNav;
    }
}

- (void)setButtonsWithImageNamed:(NSArray *)imageNames andActionDelegate:(id)delegate tintColors:(NSArray *)tintColors position:(ButtonPositionMode)position selectorsStringRepresentation:(NSArray *)buttonSelectors buttonWidth:(CGFloat)buttonWidth;
{
    if (imageNames.count != buttonSelectors.count || imageNames.count != tintColors.count) {
        return;
    }
    
    CGSize navBarSize = self.navigationBar.frame.size;
    CGFloat width = DefaultButtonWidth;
    if (buttonWidth) {
        width = buttonWidth;
    }
    CGRect buttonRect = CGRectMake(0, 0, width * 1.25,  navBarSize.height);
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *imageToShow = [[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setTintColor:tintColors[i]];
        [button setImage:imageToShow forState:UIControlStateNormal];
        SEL buttonSelector = NSSelectorFromString(buttonSelectors[i]);
        [button addTarget:delegate action:buttonSelector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonForNav = [[UIBarButtonItem alloc] initWithCustomView:button];
        buttonForNav.tag = i;
        [buttons addObject:buttonForNav];
    }
    
    if (position) {
        ((UIViewController *)delegate).navigationItem.rightBarButtonItems = buttons;
    } else {
        ((UIViewController *)delegate).navigationItem.leftBarButtonItems = buttons;
    }
}



@end
