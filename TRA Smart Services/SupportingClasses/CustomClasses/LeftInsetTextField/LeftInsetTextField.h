//
//  LeftInsetTextField.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 02.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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
