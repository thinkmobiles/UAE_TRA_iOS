//
//  
//  Consent
//
//  Created by Admin on 26.01.15.
//

@protocol OffsetTextFieldDelegate <NSObject>

@optional
- (void)textFieldDidDelete:(UITextField *)textField;
@end

IB_DESIGNABLE
@interface OffsetTextField : UITextField <UIKeyInput>

@property (assign, nonatomic) IBInspectable CGFloat leftViewOffcet;
@property (copy, nonatomic) IBInspectable NSString *leftImageName;

@property (nonatomic, assign) id <OffsetTextFieldDelegate> subDelegate;

- (void)setPlaceholderColor:(UIColor *)placholderColor withPlacholderText:(NSString *)text;

@end
