//
//  MenuCollectionViewCell.h
//  testPentagonCells
//
//  Created by Admin on 30.07.15.
//

#import "HexagonView.h"

typedef NS_ENUM(NSUInteger, PresentationMode) {
    PresentationModeUndefined = 0,
    PresentationModeModeTop = 0,
    PresentationModeModeBottom,
};

static NSString *const MenuCollectionViewCellIdentifier = @"menuCell";

@interface MenuCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet HexagonView *polygonView;
@property (weak, nonatomic) IBOutlet UIImageView *itemLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;

@property (assign, nonatomic) PresentationMode cellPresentationMode;
@property (assign, nonatomic) NSUInteger categoryID;

@end
