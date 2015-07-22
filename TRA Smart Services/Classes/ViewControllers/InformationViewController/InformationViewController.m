//
//  InformationViewController.m
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InformationViewController.h"

static NSString *const CellIdentifier = @"infoCell";
static NSString *const HeaderCellIdentifier = @"infoHeader";
static NSString *const HeaderTableText = @"Header\nTable\nText";

@interface InformationViewController ()

@property (strong, nonatomic) NSArray *arrayInfoTitle;
@property (strong, nonatomic) NSArray *arrayInfoText;
@property (strong, nonatomic) NSArray *arrayInfoImage;

@property (strong, nonatomic) NSArray *arrayInfoCell;

@end


@implementation InformationViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareDataSources];
}

#pragma mark - viewForHeaderInSection

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    InformationHeaderCell *cell=[self.tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
//    cell.contentView.backgroundColor = [UIColor redColor];
    cell.informationHeaderText.text=HeaderTableText;

    cell.contentView.frame = tableView.tableHeaderView.frame;
    
    return  cell.contentView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayInfoTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}

- (InformationTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    InformationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(InformationTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.informationCellTitle.text = self.arrayInfoTitle[indexPath.row];
    cell.informationCellText.text = self.arrayInfoText[indexPath.row];

 //   if (indexPath.row ) {
//    cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
//    cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 375.f);
//    NSLog(@"%f",cell.bounds.size.width);
 //   };
  //      cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 320.f);

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static InformationTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark - Private

- (void)prepareDataSources
{
    self.arrayInfoTitle = @[@"Sample tite 1",@"Sample tite 1",@"Sample tite 1"];
    self.arrayInfoText = @[@"ttttttttttttt\neeeeeeeeee\nsssssssss\nttttttttttttt\ntest\ntest",
                           @"1stroka",
                           @"t\ne\ns\nt"];
//    NSDictionary *dataCell1=@[""];
    
    
//    self.arrayInfoImage=@[[UIImage imageNamed:@"image1.jpg"], [UIImage imageNamed:@"image2.jpg"],
//                       [UIImage imageNamed:@"image3.jpg"]];
}



@end
