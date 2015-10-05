//
//  MenuCollectionViewCell.m
//  testPentagonCells
//
//  Created by Admin on 30.07.15.
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
    self.itemLogoImageView.image = nil;
    self.menuTitleLabel.text = @"";
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