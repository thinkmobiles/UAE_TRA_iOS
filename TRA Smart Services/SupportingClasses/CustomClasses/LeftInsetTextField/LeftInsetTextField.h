//
//  LeftInsetTextField.h
//  TRA Smart Services
//
//  Created by Admin on 02.09.15.
//

@protocol LeftInsetTextFieldDelegate <NSObject>

@optional
- (void)textFieldDidDelete:(UITextField *)textField;
@end

IB_DESIGNABLE
@interface LeftInsetTextField : UITextField

@property (assign, nonatomic) IBInspectable CGFloat insetValue;

@property (nonatomic, assign) id <LeftInsetTextFieldDelegate> subDelegate;

@end
