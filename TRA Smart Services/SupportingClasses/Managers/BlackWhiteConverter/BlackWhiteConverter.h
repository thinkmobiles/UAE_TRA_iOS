//
//  BlackWhiteConverter.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 26.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

@interface BlackWhiteConverter : NSObject

+ (instancetype)sharedManager;
- (UIImage *)convertedBlackAndWhiteImage:(UIImage *)sourceImage;


@end
