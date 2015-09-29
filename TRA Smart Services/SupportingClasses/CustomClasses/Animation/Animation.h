//
//  Animation.h
//
//
//  Created by Admin on 29.04.15.
//

@interface Animation : NSObject

+ (CABasicAnimation *)fadeAnimFromValue:(CGFloat)fromValue to:(CGFloat)toValue delegate:(id)delegate;

@end
