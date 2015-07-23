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


@interface InformationViewController ()

@property (strong, nonatomic) NSArray *arrayInfoTitle;
@property (strong, nonatomic) NSArray *arrayInfoText;
@property (strong, nonatomic) NSArray *arrayInfoImage;
@property (weak, nonatomic) NSString *headerTableText;

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
    cell.informationHeaderText.text=self.headerTableText;
    cell.contentView.frame = tableView.tableHeaderView.frame;
    
    return  cell.contentView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayInfoTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self basicCellAtIndexPath:indexPath];
}

- (InformationTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath
{
    InformationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(InformationTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.informationCellTitle.text = self.arrayInfoTitle[indexPath.row];
    cell.informationCellText.text = self.arrayInfoText[indexPath.row];
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

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

#pragma mark - Private

- (void)prepareDataSources
{
    self.headerTableText=@"Addressing Consumer disputes requert\nwith licensees on telecommunications\n services";
    
    self.arrayInfoTitle = @[@"About the service",
                            @"Service Package",
                            @"Start the Service",
                            @"Expected time",
                            @"Officer in charge of this service",
                            @"Reguired documents",
                            @"Service fee",
                            @"Terms and conditions"];
    
    self.arrayInfoText = @[@"This service invoves setting disputes of\ntelecom consumers with their service\nproviders.",
                           @"This service invoves setting disputes of\ntelecom consumers with their service\nproviders.",
                           @"This service invoves setting disputes of\ntelecom consumers with their service\nproviders.",
                           @"3 days",
                           @"Consumer Affairs Manager",
                           @"1. Identity Card\n2. Written authorization or power of attorney\nletter (for business customers only)\n3. Reference number of the complaints\nservise provider\n4. Any other document to support the\ncomplaint (such as your phone bill, acoount\ndetails, and copies of all written\ncorrespondence from your service provider, etc.",
                           @"None",
                           @"The consumer should:\n- Submit the complaint to the service\nprovider\n- Take the reference number for the\ncomplaint\n- In case, the complaint is not resolved by\nthe service provider, then raise it with the\nTRA\n- Attach the above required documents to\nthe TRA through website:www.tra.gov.ae"];
    
//    self.arrayInfoImage=@[[UIImage imageNamed:@"image1.jpg"], [UIImage imageNamed:@"image2.jpg"],
//                       [UIImage imageNamed:@"image3.jpg"]];
}



@end
