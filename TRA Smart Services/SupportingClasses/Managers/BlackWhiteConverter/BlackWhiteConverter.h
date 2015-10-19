//
//  BlackWhiteConverter.h
//  TRA Smart Services
//
//  Created by Admin on 26.08.15.
//

@interface BlackWhiteConverter : NSObject

+ (instancetype)sharedManager;
- (UIImage *)convertedBlackAndWhiteImage:(UIImage *)sourceImage;


@end
