//
//  TestViewController.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 21.09.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "TestViewController.h"
#import "InnovationsChatTableViewCell.h"

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TestViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InnovationsChatEuropeTableViewCell" bundle:nil] forCellReuseIdentifier:InnovationsChatEuropeCellIdentifier];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    InnovationsChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InnovationsChatEuropeCellIdentifier];

    
    if (indexPath.row % 2) {
        cell.marginInnovationsContainerConstraint.constant = 44;
    } else {
        cell.marginInnovationsContainerConstraint.constant = 20;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.descriptionText = @"Yout application for type Approval has been reviewd by TRA personel";

    cell.titleText = [AppHelper compactDateStringFrom:[NSDate date]];
  
    
    UIImage *logo = [UIImage imageNamed:@"ic_warn_red"];
 
    cell.logoImage = logo;
    
    return cell;
}

@end
