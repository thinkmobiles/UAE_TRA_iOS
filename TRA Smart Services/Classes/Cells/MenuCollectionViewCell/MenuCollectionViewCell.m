//
//  MenuCollectionViewCell.m
//  testPentagonCells
//
//  Created by Kirill Gorbushko on 30.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@interface MenuCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *polygonViewTopSpaceConstraint;

@end

@implementation MenuCollectionViewCell

#pragma mark - LifeCycle

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self updateViewMode:self.cellPresentationMode];
}

#pragma mark - Custom Accessors

- (void)setCellPresentationMode:(PresentationMode)cellPresentationMode
{
    _cellPresentationMode = cellPresentationMode;
    [self updateViewMode:cellPresentationMode];
}

#pragma mark - Private

- (void)updateViewMode:(PresentationMode)cellPresentationMode
{
    self.polygonViewTopSpaceConstraint.constant = cellPresentationMode ? self.frame.size.height * 0.2 : 0;
}

@end