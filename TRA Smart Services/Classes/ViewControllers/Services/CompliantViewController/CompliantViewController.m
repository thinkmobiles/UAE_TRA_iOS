//
//  CompliantViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CompliantViewController.h"
#import "NetworkManager.h"
#import "LoginViewController.h"
#import "ServiceView.h"
#import "LeftInsetTextField.h"
#import "PlaceholderTextView.h"
#import "ServicesSelectTableViewCell.h"
#import "UIImage+DrawText.h"

static NSString *const providerCellIdentifier = @"compliantProviderCell";

static CGFloat const heightSelectTableViewCell = 33.f;
static CGFloat const verticalSpaceDescriptionConstraintCompliantCustomServise = 168.f;
static CGFloat const verticalSpaceDescriptionConstraintCompliantServise = 22.f;
static CGFloat const verticalSpaceTitleConteinerConstraint = 18.f;
static CGFloat const heightContenerConstraint = 55.f;

@interface CompliantViewController ()

@property (weak, nonatomic) IBOutlet UIView *conteinerReferenceNumberView;
@property (weak, nonatomic) IBOutlet UIView *conteinerServiceProviderView;

@property (weak, nonatomic) IBOutlet UILabel *compliantTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *compliantReterenceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *compliantServicePoviderLabel;
@property (weak, nonatomic) IBOutlet UIButton *complaintSendButton;

@property (weak, nonatomic) IBOutlet BottomBorderTextField *compliantTitleTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *referenceNumberTextField;

@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet PlaceholderTextView *compliantDescriptionTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConteinerSelectedProviderConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceDescriptionConstraint;

@property (strong, nonatomic) NSArray *selectProviderDataSource;
@property (strong, nonatomic) NSString *selectedProvider;

@end

@implementation CompliantViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUIForCompliantType:self.type];
    [self prepareSelectProviderDataSource];
    self.selectedProvider = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self presentLoginIfNeeded];
    [self prepareNotification];
    [self updateNavigationControllerBar];
    self.heightTableViewConstraint.constant = heightSelectTableViewCell;
    [self addAttachButtonTextField:self.compliantTitleTextField];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[self.dynamicService currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - IABaction

- (IBAction)selectImage:(id)sender
{
    [self selectImagePickerController];
}

- (IBAction)compliantSend:(id)sender
{
    [self.view endEditing:YES];
    if (!self.compliantDescriptionTextView.text.length ||
        !self.compliantTitleTextField.text.length ||
        (self.type == ComplianTypeCustomProvider && (!self.selectedProvider.length || !self.referenceNumberTextField.text.length))){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        NSString *provider = [[[self.selectedProvider componentsSeparatedByString:@" "] firstObject] lowercaseString];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTComplianAboutServiceProvider:provider title:self.compliantTitleTextField.text description:self.compliantDescriptionTextView.text refNumber:[self.referenceNumberTextField.text integerValue] attachment:self.selectImage complienType:self.type requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierCell = self.dynamicService.language == LanguageTypeArabic ? selectProviderCellArabicUIIdentifier : selectProviderCellEuropeUIIdentifier;
    ServicesSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    if (indexPath.row) {
        cell.selectProviderLabel.text = self.selectProviderDataSource[indexPath.row];
        cell.selectProviderLabel.textColor = [self.dynamicService currentApplicationColor];
    } else {
        cell.selectProviderImage.tintColor = [self.dynamicService currentApplicationColor];
        cell.selectProviderImage.image = self.heightTableViewConstraint.constant == heightSelectTableViewCell ?  [UIImage imageNamed:@"selectTableDn"] :  [UIImage imageNamed:@"selectTableUp"];
        if (self.selectedProvider.length) {
            cell.selectProviderLabel.text = self.selectedProvider;
            cell.selectProviderLabel.textColor = [UIColor blackColor];
        } else {
            cell.selectProviderLabel.text = self.selectProviderDataSource[indexPath.row];
            cell.selectProviderLabel.textColor = [UIColor grayBorderTextFieldTextColor];
        }
    }
    [self configureCell:cell];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectProviderDataSource.count;
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
    } else {
        [self animationSelectTableView:NO];
        if (indexPath.row) {
            self.selectedProvider = self.selectProviderDataSource[indexPath.row];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGFloat deltaOffset = IS_IPHONE_5 ? 5.f : verticalSpaceTitleConteinerConstraint + heightContenerConstraint + verticalSpaceDescriptionConstraintCompliantServise;
    [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.y - deltaOffset) animated:YES];
    return YES;
}

#pragma mark - SuperclassMethods

#pragma mark - Superclass Methods

- (void)localizeUI
{
    switch (self.type) {
        case ComplianTypeCustomProvider: {
            self.title = dynamicLocalizedString(@"compliantViewController.title.compliantAboutServiceProvider");
            break;
        }
        case ComplianTypeTRAService: {
            self.title = dynamicLocalizedString(@"compliantViewController.title.comtlaintTRA");
            break;
        }
        case ComplianTypeEnquires: {
            self.title = dynamicLocalizedString(@"compliantViewController.title.enquires");
            break;
        }
    }
    self.compliantTitleTextField.placeholder = dynamicLocalizedString(@"compliantViewController.textField.placeholder");
    self.referenceNumberTextField.placeholder = dynamicLocalizedString(@"compliantViewController.textField.placeholder");
    self.compliantDescriptionTextView.placeholder = dynamicLocalizedString(@"compliantViewController.description.placeholder");
    self.compliantTitleLabel.text = dynamicLocalizedString(@"compliantViewController.compliantTitleLabel");
    self.compliantReterenceNumberLabel.text = dynamicLocalizedString(@"compliantViewController.compliantReterenceNumberLabel");
    self.compliantServicePoviderLabel.text = dynamicLocalizedString(@"compliantViewController.compliantServiceProviderLabel");
    [self.complaintSendButton setTitle:dynamicLocalizedString(@"compliantViewController.compliantSendBarButtonItem.title") forState:UIControlStateNormal];
    
    [self prepareSelectProviderDataSource];
    [self.selectTableView reloadData];
}

- (void)updateColors
{
    [super updateColors];
    
    [self.selectTableView reloadData];
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

- (void)setRTLArabicUI
{
    [super setRTLArabicUI];
    
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [super setLTREuropeUI];
    
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];
}

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.compliantTitleLabel.textAlignment = alignment;
    self.compliantTitleTextField.textAlignment = alignment;
    self.compliantReterenceNumberLabel.textAlignment = alignment;
    self.referenceNumberTextField.textAlignment = alignment;
    self.compliantServicePoviderLabel.textAlignment = alignment;
    self.compliantDescriptionTextView.textAlignment = alignment;
    [self.compliantDescriptionTextView setNeedsDisplay];
}

#pragma mark - Keyboard

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDissappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDissappear:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.scrollView setContentOffset:CGPointZero];
    }];
}

#pragma mark - Private

- (void)updateUIForCompliantType:(ComplianType)type
{
    switch (type) {
        case ComplianTypeCustomProvider: {
            self.conteinerReferenceNumberView.hidden = NO;
            self.conteinerServiceProviderView.hidden = NO;
            self.verticalSpaceDescriptionConstraint.constant = verticalSpaceDescriptionConstraintCompliantCustomServise;
            break;
        }
        case ComplianTypeEnquires:
        case ComplianTypeTRAService: {
            self.verticalSpaceDescriptionConstraint.constant = verticalSpaceDescriptionConstraintCompliantServise;
            break;
        }
    }
}

- (void)prepareSelectProviderDataSource
{
    self.selectProviderDataSource = @[dynamicLocalizedString(@"providerType.selectProvider.text"),
                                      dynamicLocalizedString(@"providerType.Du"),
                                      dynamicLocalizedString(@"providerType.Etisalat"),
                                      dynamicLocalizedString(@"providerType.Yahsat")];
}

- (void)updateNavigationControllerBar
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)animationSelectTableView:(BOOL)selected
{
    CGFloat heightTableView = heightSelectTableViewCell;
    if (selected) {
        heightTableView = heightSelectTableViewCell * self.selectProviderDataSource.count;
    }
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.heightTableViewConstraint.constant = heightTableView;
        weakSelf.heightConteinerSelectedProviderConstraint.constant = heightTableView + 22.f;
        weakSelf.verticalSpaceDescriptionConstraint.constant = heightTableView + verticalSpaceDescriptionConstraintCompliantCustomServise - heightSelectTableViewCell;
        [weakSelf.view layoutIfNeeded];
    }];
    [self.selectTableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell
{
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.size.height + 1, cell.frame.size.width, cell.frame.size.height)];
    selectedView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:selectedView];
}

@end