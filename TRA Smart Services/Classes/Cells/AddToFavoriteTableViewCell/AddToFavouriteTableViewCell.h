//
//  FavouriteTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 17.08.15.
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

- (void)setServiceFavourite:(BOOL)isFavourite;

@end