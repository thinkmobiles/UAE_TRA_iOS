//
//  CompliantViewController.m
//  TRA Smart Services
//
//  Created by Admin on 14.08.15.
//

#import "CompliantViewController.h"
#import "LoginViewController.h"
#import "ServiceView.h"
#import "LeftInsetTextField.h"
#import "PlaceholderTextView.h"
#import "ServicesSelectTableViewCell.h"
#import "UIImage+DrawText.h"

static NSString *const providerCellIdentifier = @"compliantProviderCell";

static CGFloat const HeightSelectTableViewCell = 40.f;
static CGFloat const VerticalSpaceDescriptionConstraintCompliantCustomServise = 155.f;
static CGFloat const VerticalSpaceDescriptionConstraintCompliantServise = 25.f;

@interface CompliantViewController ()

@property (weak, nonatomic) IBOutlet UIButton *complaintSendButton;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet BottomBorderTextField *compliantTitleTextField;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *referenceNumberTextField;

@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet PlaceholderTextView *compliantDescriptionTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConteinerSelectedProviderConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceDescriptionConstraint;

@property (strong, nonatomic) NSArray *selectProviderDataSource;
@property (assign, nonatomic) NSInteger selectedProvider;
@property (strong, nonatomic) NSArray *keyForServerProvider;

@end

@implementation CompliantViewController

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _type = ComplianTypeEnquires;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyForServerProvider = @[@"du", @"Etisalat", @"Yahsat"];
    
    [self updateUIForCompliantType:self.type];
    [self prepareSelectProviderDataSource];
    self.selectedProvider = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self presentLoginIfNeededAndPopToRootController:nil];
    [self prepareNotification];
    [self updateNavigationControllerBar];
    self.heightTableViewConstraint.constant = HeightSelectTableViewCell;
    [self addAttachButtonTextField:self.compliantTitleTextField];
    [self configureKeyboardButtonDone:self.compliantDescriptionTextView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[self.dynamicService currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - IABaction

- (IBAction)compliantSend:(id)sender
{
    [self.view endEditing:YES];
    
    if (!self.compliantDescriptionTextView.text.length || !self.compliantTitleTextField.text.length || (self.type == ComplianTypeCustomProvider && !self.referenceNumberTextField.text.length)){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else if (self.type == ComplianTypeCustomProvider && self.referenceNumberTextField.text.length < 4) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatMobileTooShort")];
    } else if (self.type == ComplianTypeCustomProvider && ![self.referenceNumberTextField.text isValidPhoneNumber]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatMobile")];
    } else if (self.type == ComplianTypeCustomProvider && !self.selectedProvider) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.PleaseChooseServiceProvider")];
    } else {
        [self sentCompliant];
    }
}

- (void)sentCompliant
{
    TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
    if (self.selectedProvider < 1) {
        self.selectedProvider = 1;
    }
    __weak typeof (self) weakSelf = self;
    NSString *provider = self.keyForServerProvider[self.selectedProvider - 1];
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTComplianAboutServiceProvider:provider title:self.compliantTitleTextField.text description:self.compliantDescriptionTextView.text refNumber:[self.referenceNumberTextField.text integerValue] attachment:self.selectImage complienType:self.type requestResult:^(id response, NSError *error) {
        if (error) {
            [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
        } else {
            [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            [weakSelf clearUI];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, TRAAnimationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            loader.ratingView.hidden = NO;
        });
    }];
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
        cell.selectProviderImage.image = self.heightTableViewConstraint.constant == HeightSelectTableViewCell ?  [UIImage imageNamed:@"selectTableDn"] :  [UIImage imageNamed:@"selectTableUp"];
        if (self.selectedProvider) {
            cell.selectProviderLabel.text = self.selectProviderDataSource[self.selectedProvider];
            cell.selectProviderLabel.textColor = [self.dynamicService currentApplicationColor];
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
    return HeightSelectTableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [self.view endEditing:YES];

    if (self.heightTableViewConstraint.constant == HeightSelectTableViewCell) {
        [self animationSelectTableView:YES];
        self.selectedProvider = 0;
    } else {
        [self animationSelectTableView:NO];
        if (indexPath.row) {
            self.selectedProvider = indexPath.row;
            [self.selectTableView reloadData];
        }
    }
    [self.compliantDescriptionTextView changeBorder];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGFloat deltaOffset = IS_IPHONE_5 ? 5.f : 25.f + HeightSelectTableViewCell + VerticalSpaceDescriptionConstraintCompliantServise;
    [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.y - deltaOffset) animated:YES];
    return YES;
}

#pragma mark - SuperclassMethods

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
    self.compliantTitleTextField.placeholder = dynamicLocalizedString(@"compliantViewController.compliantTitleTextField.placeholder");
    self.referenceNumberTextField.placeholder = dynamicLocalizedString(@"compliantViewController.referenceNumberTextField.placeholder");
    self.compliantDescriptionTextView.placeholder = dynamicLocalizedString(@"compliantViewController.description.placeholder");
    [self.complaintSendButton setTitle:dynamicLocalizedString(@"compliantViewController.compliantSendBarButtonItem.title") forState:UIControlStateNormal];
    
    [self prepareSelectProviderDataSource];
    [self.selectTableView reloadData];
}

- (void)updateColors
{
    [super updateColors];
    
    self.separatorView.backgroundColor = [self.dynamicService currentApplicationColor];
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
    self.compliantTitleTextField.textAlignment = alignment;
    self.referenceNumberTextField.textAlignment = alignment;
    self.compliantDescriptionTextView.textAlignment = alignment;
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

- (void)clearUI
{
    self.compliantTitleTextField.text = @"";
    self.referenceNumberTextField.text = @"";
    self.compliantDescriptionTextView.text = @"";
    self.selectImage = nil;    
    self.selectedProvider = 0;
    [self.selectTableView reloadData];
}

- (void)updateUIForCompliantType:(ComplianType)type
{
    switch (type) {
        case ComplianTypeCustomProvider: {
            self.referenceNumberTextField.hidden = NO;
            self.selectTableView.hidden = NO;
            self.separatorView.hidden = NO;
            self.verticalSpaceDescriptionConstraint.constant = VerticalSpaceDescriptionConstraintCompliantCustomServise;
            break;
        }
        case ComplianTypeEnquires:
        case ComplianTypeTRAService: {
            self.verticalSpaceDescriptionConstraint.constant = VerticalSpaceDescriptionConstraintCompliantServise;
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
    CGFloat heightTableView = HeightSelectTableViewCell;
    if (selected) {
        heightTableView = HeightSelectTableViewCell * self.selectProviderDataSource.count;
    }
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.heightTableViewConstraint.constant = heightTableView;
        weakSelf.heightConteinerSelectedProviderConstraint.constant = heightTableView;
        weakSelf.verticalSpaceDescriptionConstraint.constant = heightTableView + VerticalSpaceDescriptionConstraintCompliantCustomServise - HeightSelectTableViewCell;
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