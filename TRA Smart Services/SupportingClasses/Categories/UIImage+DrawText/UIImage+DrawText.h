//
//  UIImage+DrawText.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

@interface UIImage (DrawText)

- (UIImage *)drawText:(NSString *)textToDraw atPoint:(CGPoint)pointToDraw withAttributes:(NSDictionary *)textAttributes;
- (UIImage *)drawText:(NSString *)textToDraw atPoint:(CGPoint)pointToDraw withAttributes:(NSDictionary *)textAttributes inRect:(CGRect)rect;
+ (UIImage *)imageWithColor:(UIColor *)color inRect:(CGRect)imageRect;

@end
