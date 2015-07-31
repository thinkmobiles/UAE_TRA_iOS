//
//  MenuCollectionViewCell.h
//  testPentagonCells
//
//  Created by Kirill Gorbushko on 30.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
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

@end
