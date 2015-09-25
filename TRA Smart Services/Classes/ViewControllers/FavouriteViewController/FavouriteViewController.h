//
//  FavouriteViewController.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseSearchableViewController.h"
#import "FavouriteTableViewCell.h"

static CGFloat const AnimationDuration = 0.3f;

@interface FavouriteViewController : BaseSearchableViewController <UITableViewDelegate, UITableViewDataSource, FavouriteTableViewCellDelegate>

@property (strong, nonatomic) CALayer *arcDeleteZoneLayer;
@property (strong, nonatomic) CALayer *contentFakeIconLayer;
@property (strong, nonatomic) CALayer *shadowFakeIconLayer;

- (CGFloat)headerHeight;

@end
