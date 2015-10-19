//
//  UIPlaceholderTextView.h
//  PlaceholderTextView
//
//  Created by Roma on 07.09.15.
//

IB_DESIGNABLE
@interface PlaceholderTextView : BottomBorderTextView

@property (strong, nonatomic) IBInspectable NSString *placeholder;
@property (strong, nonatomic) IBInspectable UIColor *placeholderColor;
@property (assign, nonatomic) IBInspectable CGFloat insetValue;

- (void)textChanged:(NSNotification *)notification;

@end
