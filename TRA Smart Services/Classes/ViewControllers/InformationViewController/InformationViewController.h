//
//  InformationViewController.h
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//
#import "InformationTableViewCell.h"
#import "InformationHeaderCell.h"


@interface InformationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
