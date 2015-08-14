//
//  
//
//  Created by Kirill Gorbushko on 25.06.15.
//
//

typedef NS_ENUM(NSUInteger, ButtonPositionMode) {
    ButtonPositionModeLeft,
    ButtonPositionModeRight
};

@interface UINavigationController (TopButton)

- (void)setButtonWithImageNamed:(NSString *)image andActionDelegate:(id)delegate tintColor:(UIColor *)tintColor position:(ButtonPositionMode)position selector:(SEL)buttonSelector;
- (void)setButtonsWithImageNamed:(NSArray *)imageNames andActionDelegate:(id)delegate tintColors:(NSArray *)tintColors position:(ButtonPositionMode)position selectorsStringRepresentation:(NSArray *)buttonSelectors buttonWidth:(CGFloat)buttonWidth;

@end
