//
//  CategoryCollectionViewCell.m
//  TRA Smart Services
//
//  Created by Admin on 30.07.15.
//

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self resetParameters];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self resetParameters];
}

#pragma mark - Public

- (void)setTintColorForLabel:(UIColor *)color
{
    self.categoryTitleLabel.textColor = color;
}

#pragma mark - Private

- (void)resetParameters
{
    self.categoryLogoImageView.image = nil;
    self.categoryTitleLabel.text = @"";
    [self.polygonView removeAllDrawings];
    self.categoryTitleLabel.textColor = [UIColor whiteColor];
}

@end
