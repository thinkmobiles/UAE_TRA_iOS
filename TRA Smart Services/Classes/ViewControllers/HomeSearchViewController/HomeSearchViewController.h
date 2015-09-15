//
//  HomeSearchViewController.h
//  TRA Smart Services
//
//  Created by RomaVizenko on 09.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseDynamicUIViewController.h"

@interface HomeSearchViewController : BaseDynamicUIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImage *fakeBackground;
@property (strong, nonatomic) void (^selectedServiceIDHomeSearch)(NSInteger selectedServiseID);

@end
