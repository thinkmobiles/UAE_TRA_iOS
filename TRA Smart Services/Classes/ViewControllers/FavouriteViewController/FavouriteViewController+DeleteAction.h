//
//  FavouriteViewController+DeleteAction.h
//  TRA Smart Services
//
//  Created by Admin on 19.09.15.
//

#import "FavouriteViewController.h"

@interface FavouriteViewController (DeleteAction)

- (void)drawDeleteAreaOnTable:(UITableView *)tableView;
- (void)animateDeleteZoneAppearence;
- (void)selectDeleteZone:(BOOL)select;
- (void)animateDeleteZoneDisapearing;
- (void)removeDeleteZone;

@end
