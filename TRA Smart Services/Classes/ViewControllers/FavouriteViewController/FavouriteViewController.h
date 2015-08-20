//
//  FavouriteViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseSearchableViewController.h"
#import "FavouriteTableViewCell.h"

@interface FavouriteViewController : BaseSearchableViewController <UITabBarDelegate, UITableViewDataSource, FavouriteTableViewCellDelegate>

@end
