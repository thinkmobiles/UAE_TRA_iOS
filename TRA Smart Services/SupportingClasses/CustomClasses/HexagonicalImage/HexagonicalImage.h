//
//  HexagonicalImage.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 02.08.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexagonicalImage : NSObject

- (instancetype)initWithRectColor:(UIColor *)rectColor;

- (UIImage *)randomHexagonImageInRect:(CGRect)imageRect;

@end
