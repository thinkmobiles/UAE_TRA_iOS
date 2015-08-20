//
//  FavouriteTableViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *removeArabicButton;

@property (strong, nonatomic) UIImage *logoImage;
@property (copy, nonatomic) NSString *descriptionText;

@property (weak, nonatomic) id <FavouriteTableViewCellDelegate> delegate;

- (void)markRemoveButtonSelected:(BOOL)selected;

@end