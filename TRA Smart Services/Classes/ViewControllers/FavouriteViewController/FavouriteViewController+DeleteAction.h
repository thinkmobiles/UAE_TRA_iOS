//
//  FavouriteViewController+DeleteAction.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 19.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "FavouriteViewController.h"

@interface FavouriteViewController (DeleteAction)

- (void)drawDeleteAreaOnTable:(UITableView *)tableView;
- (void)animateDeleteZoneAppearence;
- (void)selectDeleteZone:(BOOL)select;
- (void)animateDeleteZoneDisapearing;
- (void)removeDeleteZone;

@end
