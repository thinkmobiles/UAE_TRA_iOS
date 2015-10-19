//
//  FavouriteTableViewCell.h
//  TRA Smart Services
//
//  Created by Admin on 17.08.15.
//

@class FavouriteTableViewCell;

static NSString *const FavouriteEuroCellIdentifier = @"euroFavCell";
static NSString *const FavouriteArabicCellIdentifier = @"arabicFavCell";

@protocol FavouriteTableViewCellDelegate <NSObject>

@optional
- (void)favouriteServiceInfoButtonDidPressedInCell:(FavouriteTableViewCell *)cell;
- (void)favouriteServiceDeleteButtonDidReceiveGestureRecognizerInCell:(FavouriteTableViewCell *)cell gesture:(UILongPressGestureRecognizer *)gesture;

@end

@interface FavouriteTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *logoImage;
@property (copy, nonatomic) NSString *descriptionText;

@property (weak, nonatomic) id <FavouriteTableViewCellDelegate> delegate;

- (void)markRemoveButtonSelected:(BOOL)selected;

@end