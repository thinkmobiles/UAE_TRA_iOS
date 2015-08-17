//
//  FavouriteTableViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

@class FavouriteTableViewCell;

static NSString *const FavouriteEuropianTableViewCellIdentifier = @"favouriteEuropianCell";
static NSString *const FavouriteArabicTableViewCellIdentifier = @"favouriteArabicCell";

@protocol FavouriteTableViewCellDelegate <NSObject>

@optional
- (void)favouriteServiceInfoButtonDidPressedInCell:(FavouriteTableViewCell *)cell;

@end

@interface FavouriteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *favourieDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (strong, nonatomic) UIImage *logoImage;
@property (weak, nonatomic) id <FavouriteTableViewCellDelegate> delegate;


@end
