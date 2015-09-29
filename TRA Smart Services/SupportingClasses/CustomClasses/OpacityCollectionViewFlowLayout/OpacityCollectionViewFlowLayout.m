//
//  OpacityCollectionViewFlowLayout.m
//  TRA Smart Services
//
//  Created by Admin on 30.07.15.
//

#import "OpacityCollectionViewFlowLayout.h"

@implementation OpacityCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in attributesToReturn) {
        CGSize cellSize = attributes.frame.size;
        CGFloat contentOffsetY = self.collectionView.contentOffset.y;
        CGFloat offset = attributes.frame.origin.y - contentOffsetY;
        if (offset < 0) {
            CGFloat alphaValue = (cellSize.height - ABS(offset))/ cellSize.height;
            if (alphaValue < 0.2) {
                alphaValue = 0.f;
            }
            attributes.alpha = alphaValue;
        } else {
            attributes.alpha = 1.0f;
        }
    }
    return attributesToReturn;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    return currentItemAttributes;
}

@end