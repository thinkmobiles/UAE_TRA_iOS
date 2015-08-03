//
//  InformationViewController.m
//  TRA Smart Services
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "InformationHeaderCell.h"

@interface InformationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayInfoTitle;
@property (strong, nonatomic) NSArray *arrayInfoText;
@property (strong, nonatomic) NSArray *arrayInfoImage;

@end

@implementation InformationViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareDataSources];
}

#pragma mark - IBActions

- (IBAction)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    InformationHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InformationHeaderCellIdentifier];
    cell.informationHeaderText.text = dynamicLocalizedString(@"information.service.title");
    cell.contentView.frame = tableView.tableHeaderView.frame;
    return cell.contentView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayInfoTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InformationTableViewCellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}

#pragma mark - Private

#pragma mark - CellConfiguration

- (void)configureBasicCell:(InformationTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.informationCellTitle.text = self.arrayInfoTitle[indexPath.row];
    cell.informationCellText.text = self.arrayInfoText[indexPath.row];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static InformationTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:InformationTableViewCellIdentifier];
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

#pragma mark - DataSourceConfiguration

- (void)prepareDataSources
{
    //test
    self.arrayInfoText = @[@"This service invoves setting disputes of\ntelecom consumers with their service\nproviders.",
                           @"This service invoves setting disputes of\ntelecom consumers with their service\nproviders.",
                           @"This service invoves setting disputes of\ntelecom consumers with their service\nproviders.",
                           @"3 days",
                           @"Consumer Affairs Manager",
                           @"1. Identity Card\n2. Written authorization or power of attorney\nletter (for business customers only)\n3. Reference number of the complaints\nservise provider\n4. Any other document to support the\ncomplaint (such as your phone bill, acoount\ndetails, and copies of all written\ncorrespondence from your service provider, etc.",
                           @"None",
                           @"The consumer should:\n- Submit the complaint to the service\nprovider\n- Take the reference number for the\ncomplaint\n- In case, the complaint is not resolved by\nthe service provider, then raise it with the\nTRA\n- Attach the above required documents to\nthe TRA through website:www.tra.gov.ae"];
}

- (void)localizeUI
{
    NSArray *keyLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceList" ofType:@"plist"]];
    for (int i = 0; i < keyLists.count; i++) {
        if (!self.arrayInfoTitle){
            self.arrayInfoTitle = [[NSMutableArray alloc] init];
        }
        [self.arrayInfoTitle addObject:dynamicLocalizedString(keyLists[i])];
    }
}

- (void)updateColors
{

}

@end