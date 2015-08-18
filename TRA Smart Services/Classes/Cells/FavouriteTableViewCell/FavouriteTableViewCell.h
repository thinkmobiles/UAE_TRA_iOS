//
//  FavouriteTableViewCell.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 17.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

@class FavouriteTableViewCell;

static NSString *const FavouriteEuropianTableViewCellIdentifier = @"favouriteEuropianCell";

@protocol FavouriteTableViewCellDelegate <NSObject>

@optional
- (void)favouriteServiceInfoButtonDidPressedInCell:(FavouriteTableViewCell *)cell;

@end

@interface FavouriteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *removeArabicButton;

@property (weak, nonatomic) IBOutlet UIView *arabicContent;
@property (weak, nonatomic) IBOutlet UIView *europeanContent;

@property (strong, nonatomic) UIImage *logoImage;
@property (copy, nonatomic) NSString *descriptionText;

@property (weak, nonatomic) id <FavouriteTableViewCellDelegate> delegate;

@end