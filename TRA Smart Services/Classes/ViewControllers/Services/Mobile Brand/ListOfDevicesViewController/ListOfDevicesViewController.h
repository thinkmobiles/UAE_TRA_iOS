//
//  ListOfDevicesViewController.h
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//


@interface ListOfDevicesViewController : BaseServiceViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataSource;

@end
