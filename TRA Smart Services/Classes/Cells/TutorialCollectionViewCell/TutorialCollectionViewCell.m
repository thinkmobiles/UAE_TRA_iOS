//
//  PTTutorialCell.m
//  PTSquared
//
//  Created by Kirill on 11/10/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "TutorialCollectionViewCell.h"

@implementation TutorialCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

@end