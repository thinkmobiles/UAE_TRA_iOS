//
//  UIImage+DrawText.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 31.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "UIImage+DrawText.h"

@implementation UIImage (DrawText)

#pragma mark - Public

- (UIImage *)drawText:(NSString *)textToDraw atPoint:(CGPoint)pointToDraw withAttributes:(NSDictionary *)textAttributes
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [textToDraw drawAtPoint:pointToDraw withAttributes:textAttributes];
    UIImage *imageWithText = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageWithText;
}

- (UIImage *)drawText:(NSString *)textToDraw atPoint:(CGPoint)pointToDraw withAttributes:(NSDictionary *)textAttributes inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [textToDraw drawAtPoint:pointToDraw withAttributes:textAttributes];
    UIImage *imageWithText = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageWithText;
}

+ (UIImage *)imageWithColor:(UIColor *)color inRect:(CGRect)imageRect
{
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, imageRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
