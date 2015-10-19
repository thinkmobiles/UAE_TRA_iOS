//
//  FavouriteViewController.h
//  TRA Smart Services
//
//  Created by Admin on 14.08.15.
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
