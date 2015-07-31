//
//  CategoryCollectionViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 30.07.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "HexagonView.h"

static NSString *const CategoryCollectionViewCellIdentifier = @"categoryCell";

@interface CategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet HexagonView *polygonView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;

@end