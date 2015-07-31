//
//  HexagonView.h
//  testPentagonCells
//
//  Created by Kirill Gorbushko on 30.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HexagonView : UIView

@property (strong, nonatomic) IBInspectable UIColor *viewFillColor;
@property (strong, nonatomic) IBInspectable UIColor *viewStrokeColor;

- (void)setGradientWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

@end
