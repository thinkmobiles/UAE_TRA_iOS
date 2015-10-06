//
//  InnovationsViewController.m
//  TRA Smart Services
//
//  Created by Admin on 29.09.15.
//

#import "InnovationsViewController.h"
#import "PlaceholderTextView.h"
#import "ServicesSelectTableViewCell.h"

static CGFloat const heightSelectTableViewCell = 35.f;

@interface InnovationsViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *innovationsTitleTextField;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *separatopSelectView;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableViewConstraint;

@property (strong, nonatomic) NSArray *selectInnovateDataSource;
@property (assign, nonatomic) NSInteger selectedInnovate;

@end

@implementation InnovationsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedInnovate = 0;
    [self configureKeyboardButtonDone:self.descriptionTextView];
    [self prepareDataSource];
}

#pragma mark - IBAction

- (IBAction)sendInfo:(id)sender
{
    if (!self.innovationsTitleTextField.text.length || !self.descriptionTextView.text.length || !self.selectedInnovate) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSNoCRMServicePostInnovationTitle:self.innovationsTitleTextField.text message:self.descriptionTextView.text type:@(self.selectedInnovate) responseBlock:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
            } else {
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TRAAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                loader.ratingView.hidden = NO;
            });
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierCell = self.dynamicService.language == LanguageTypeArabic ? selectProviderCellArabicUIIdentifier : selectProviderCellEuropeUIIdentifier;
    ServicesSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    if (indexPath.row) {
        cell.selectProviderLabel.text = self.selectInnovateDataSource[indexPath.row];
        cell.selectProviderLabel.textColor = [self.dynamicService currentApplicationColor];
    } else {
        cell.selectProviderImage.tintColor = [self.dynamicService currentApplicationColor];
        cell.selectProviderImage.image = self.heightTableViewConstraint.constant == heightSelectTableViewCell ?  [UIImage imageNamed:@"selectTableDn"] :  [UIImage imageNamed:@"selectTableUp"];
        if (self.selectedInnovate) {
            cell.selectProviderLabel.text = self.selectInnovateDataSource[self.selectedInnovate];
            cell.selectProviderLabel.textColor = [self.dynamicService currentApplicationColor];
        } else {
            cell.selectProviderLabel.text = self.selectInnovateDataSource[indexPath.row];
            cell.selectProviderLabel.textColor = [UIColor lightGrayColor];
        }
    }
    [self configureCell:cell];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
{
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.size.height + 1, cell.frame.size.width, cell.frame.size.height)];
    selectedView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:selectedView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectInnovateDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightSelectTableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (self.heightTableViewConstraint.constant == heightSelectTableViewCell) {
        [self animationSelectTableView:YES];
        self.selectedInnovate = 0;
    } else {
        [self animationSelectTableView:NO];
        if (indexPath.row) {
            self.selectedInnovate = indexPath.row;
            [self.selectTableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"innovationsViewController.title");
    [self.submitButton setTitle:dynamicLocalizedString(@"innovationsViewController.submitButton") forState:UIControlStateNormal];
    self.innovationsTitleTextField.placeholder = dynamicLocalizedString(@"innovationsViewController.innovationsTitleTextField.placeholder");
    self.descriptionTextView.placeholder = dynamicLocalizedString(@"innovationsViewController.descriptionTextView.placeholder");
    [self prepareDataSource];
    [self.selectTableView reloadData];
}

- (void)updateColors
{
    [super updateColors];
    
    self.separatopSelectView.backgroundColor = [self.dynamicService currentApplicationColor];
    [super updateBackgroundImageNamed:@"fav_back_orange"];
}

- (void)setRTLArabicUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];\
}

#pragma mark - Private

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.innovationsTitleTextField.textAlignment = alignment;
    self.descriptionTextView.textAlignment = alignment;
}

- (void)animationSelectTableView:(BOOL)selected
{
    CGFloat heightTableView = heightSelectTableViewCell;
    if (selected) {
        heightTableView = heightSelectTableViewCell * self.selectInnovateDataSource.count;
    }
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.heightTableViewConstraint.constant = heightTableView;
        [weakSelf.view layoutIfNeeded];
    }];
    [self.selectTableView reloadData];
}


- (void)prepareDataSource
{
    self.selectInnovateDataSource = @[
                                      dynamicLocalizedString(@"innovationsViewController.selectInnovativeIdeasFor0"),
                                      dynamicLocalizedString(@"innovationsViewController.selectInnovativeIdeasFor1"),
                                      dynamicLocalizedString(@"innovationsViewController.selectInnovativeIdeasFor2"),
                                      dynamicLocalizedString(@"innovationsViewController.selectInnovativeIdeasFor3"),
                                      dynamicLocalizedString(@"innovationsViewController.selectInnovativeIdeasFor4"),
                                      dynamicLocalizedString(@"innovationsViewController.selectInnovativeIdeasFor5"),
                                      dynamicLocalizedString(@"innovationsViewController.selectInnovativeIdeasFor6"),
                                      ];
}

@end
