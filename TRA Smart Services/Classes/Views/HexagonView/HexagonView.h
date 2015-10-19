//
//  HexagonView.h
//  testPentagonCells
//
//  Created by Admin on 30.07.15.
//

IB_DESIGNABLE
@interface HexagonView : UIView

@property (strong, nonatomic) IBInspectable UIColor *viewFillColor;
@property (strong, nonatomic) IBInspectable UIColor *viewStrokeColor;

- (void)setGradientWithTopColors:(NSArray *)colors;
- (void)removeAllDrawings;

@end
