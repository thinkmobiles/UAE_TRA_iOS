//
//  HomeSearchResultViewController.h
//  TRA Smart Services
//
//  Created by RomaVizenko on 15.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseDynamicUIViewController.h"

@interface HomeSearchResultViewController : BaseDynamicUIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataSource;

@end
