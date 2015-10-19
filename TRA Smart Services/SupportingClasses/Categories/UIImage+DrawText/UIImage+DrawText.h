//
//  UIImage+DrawText.h
//  TRA Smart Services
//
//  Created by Admin on 31.07.15.
//

@interface UIImage (DrawText)

- (UIImage *)drawText:(NSString *)textToDraw atPoint:(CGPoint)pointToDraw withAttributes:(NSDictionary *)textAttributes;
- (UIImage *)drawText:(NSString *)textToDraw atPoint:(CGPoint)pointToDraw withAttributes:(NSDictionary *)textAttributes inRect:(CGRect)rect;
+ (UIImage *)imageWithColor:(UIColor *)color inRect:(CGRect)imageRect;

@end
