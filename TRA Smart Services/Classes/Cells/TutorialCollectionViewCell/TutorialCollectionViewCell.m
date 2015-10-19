//
//  PTTutorialCell.m
//  PTSquared
//
//  Created by Admin on 11/10/14.
//

#import "TutorialCollectionViewCell.h"

@implementation TutorialCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

@end