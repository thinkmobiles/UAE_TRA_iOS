//
//  FavouriteTableViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

@class AddToFavouriteTableViewCell;

static NSString *const AddToFavouriteEuroCellIdentifier = @"euroAddToFavCell";
static NSString *const AddToFavouriteArabicCellIdentifier = @"arabicAddToFavCell";

@protocol AddToFavouriteTableViewCellDelegate <NSObject>

@optional
- (void)addRemoveFavoriteService:(NSIndexPath *)indexPath;

@end

@interface AddToFavouriteTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *logoImage;
@property (copy, nonatomic) NSString *descriptionText;
@property (weak, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id <AddToFavouriteTableViewCellDelegate> delegate;

@end