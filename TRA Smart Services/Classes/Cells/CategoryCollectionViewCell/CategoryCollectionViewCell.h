//
//  CategoryCollectionViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 30.07.15.
//

#import "HexagonView.h"

static NSString *const CategoryCollectionViewCellIdentifier = @"categoryCell";

@interface CategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet HexagonView *polygonView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;

@property (assign, nonatomic) NSUInteger categoryID;

- (void)setTintColorForLabel:(UIColor *)color;

@end