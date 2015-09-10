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

static NSString *const providerCellIdentifier = @"compliantProviderCell";
static CGFloat const heightSelectTableViewCell = 33.f;
static CGFloat const verticalSpaceDescriptionConstraintCompliantCustomServise = 168.f;
static CGFloat const verticalSpaceDescriptionConstraintCompliantServise = 22.f;
static CGFloat const verticalSpaceTitleConteinerConstraint = 18.f;
static CGFloat const heightContenerConstraint = 55.f;

@interface CompliantViewController ()

@property (weak, nonatomic) IBOutlet UITextField *compliantTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *referenceNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *compliantTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *compliantReterenceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *compliantServicePoviderLabel;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *compliantDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet UIView *conteinerReferenceNumberView;
@property (weak, nonatomic) IBOutlet UIView *conteinerServiceProviderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConteinerSelectedProviderConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceDescriptionConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet ServiceView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *topHolderView;
@property (strong, nonatomic) UIImage *navigationBarBackgroundImage;
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
    [self prepareTopView];
    [self updateNavigationControllerBar];
    self.heightTableViewConstraint.constant = heightSelectTableViewCell;
    self.navigationBarBackgroundImage = self.navigationController.navigationBar.backIndicatorImage;
    [self addAttachButtonTitleTextField];
    [self addSendButtonToNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
    [self.navigationController.navigationBar setBackgroundImage:self.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
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
        [AppHelper showLoader];
        NSString *provider = [[[self.selectedProvider componentsSeparatedByString:@" "] firstObject] lowercaseString];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTComplianAboutServiceProvider:provider title:self.compliantTitleTextField.text description:self.compliantDescriptionTextView.text refNumber:[self.referenceNumberTextField.text integerValue] attachment:self.selectImage complienType:self.type requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.success")];
            }
            [AppHelper hideLoader];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierCell;
    if ([DynamicUIService service].language == LanguageTypeArabic){
        identifierCell = selectProviderCellArabicUIIdentifier;
    } else {
        identifierCell = selectProviderCellEuropeUIIdentifier;
    }
    ServicesSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    if (indexPath.row) {
        cell.selectProviderLabel.text = self.selectProviderDataSource[indexPath.row];
        cell.selectProviderLabel.textColor = [[DynamicUIService service] currentApplicationColor];
    } else {
        cell.selectProviderImage.tintColor = [[DynamicUIService service] currentApplicationColor];
        if (self.heightTableViewConstraint.constant == heightSelectTableViewCell) {
            cell.selectProviderImage.image = [UIImage imageNamed:@"selectTableDn"];
        } else {
            cell.selectProviderImage.image = [UIImage imageNamed:@"selectTableUp"];
        }
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
    [self.compliantTitleTextField resignFirstResponder];
    [self.referenceNumberTextField resignFirstResponder];
    [self.compliantDescriptionTextView resignFirstResponder];

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
    CGFloat deltaOffset;
    if (IS_IPHONE_5) {
        deltaOffset = 5.f;
    } else {
        deltaOffset = verticalSpaceTitleConteinerConstraint + heightContenerConstraint + verticalSpaceDescriptionConstraintCompliantServise;
    }
    [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.y - deltaOffset) animated:YES];
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"compliantViewController.title");
    self.compliantTitleTextField.placeholder = dynamicLocalizedString(@"compliantViewController.textField.placeholder");
    self.referenceNumberTextField.placeholder = dynamicLocalizedString(@"compliantViewController.textField.placeholder");
    self.compliantDescriptionTextView.placeholder = dynamicLocalizedString(@"compliantViewController.description.placeholder");
    self.compliantTitleLabel.text = dynamicLocalizedString(@"compliantViewController.compliantTitleLabel");
    self.compliantReterenceNumberLabel.text = dynamicLocalizedString(@"compliantViewController.compliantReterenceNumberLabel");
    self.compliantServicePoviderLabel.text = dynamicLocalizedString(@"compliantViewController.compliantServiceProviderLabel");
    
    [self prepareSelectProviderDataSource];
    [self.selectTableView reloadData];
}

- (void)updateColors
{

    
    [AppHelper setStyleGrayColorForLayer:self.compliantDescriptionTextView.layer];
    [self.selectTableView reloadData];
}

- (void)setRTLArabicUI
{
    [super setRTLArabicUI];
    
    self.compliantTitleLabel.textAlignment = NSTextAlignmentRight;
    self.compliantTitleTextField.textAlignment = NSTextAlignmentRight;
    self.compliantReterenceNumberLabel.textAlignment = NSTextAlignmentRight;
    self.referenceNumberTextField.textAlignment = NSTextAlignmentRight;
    self.compliantServicePoviderLabel.textAlignment = NSTextAlignmentRight;
    self.compliantDescriptionTextView.textAlignment = NSTextAlignmentRight;
    [self.compliantDescriptionTextView setNeedsDisplay];
}

- (void)setLTREuropeUI
{
    [super setLTREuropeUI];
    
    self.compliantTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.compliantTitleTextField.textAlignment = NSTextAlignmentLeft;
    self.compliantReterenceNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.referenceNumberTextField.textAlignment = NSTextAlignmentLeft;
    self.compliantServicePoviderLabel.textAlignment = NSTextAlignmentLeft;
    self.compliantDescriptionTextView.textAlignment = NSTextAlignmentLeft;
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
        [weakSelf.view layoutIfNeeded];
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
        default:
            break;
    }
}

- (void)prepareSelectProviderDataSource
{
    self.selectProviderDataSource = @[dynamicLocalizedString(@"providerType.selectProvider.text"),
                                      dynamicLocalizedString(@"providerType.Du"),
                                      dynamicLocalizedString(@"providerType.Etisalat"),
                                      dynamicLocalizedString(@"providerType.Yahsat")];
}

- (void)prepareTopView
{
    UIImage *logo = [UIImage imageNamed:@"ic_edit_hex"];
    self.serviceView.serviceImage.image = [logo imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.topHolderView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
}

- (void)updateNavigationControllerBar
{
    [self.navigationController presentTransparentNavigationBarAnimated:NO];
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

- (void)addAttachButtonTitleTextField
{
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonAttachImage = [UIImage imageNamed:@"btn_attach"];
    [attachButton setImage:buttonAttachImage forState:UIControlStateNormal];
    [attachButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    attachButton.backgroundColor = [UIColor clearColor];
    attachButton.tintColor = [[DynamicUIService service] currentApplicationColor];
    [attachButton setFrame:CGRectMake(0, 0, self.compliantTitleTextField.frame.size.height, self.compliantTitleTextField.frame.size.height)];

    if ([DynamicUIService service].language == LanguageTypeArabic) {
        [attachButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, attachButton.frame.size.width - buttonAttachImage.size.width)];
        self.compliantTitleTextField.leftView = attachButton;
        self.compliantTitleTextField.leftViewMode = UITextFieldViewModeAlways;
        self.compliantTitleTextField.rightView = nil;
    } else {
        [attachButton setImageEdgeInsets:UIEdgeInsetsMake(0, attachButton.frame.size.width - buttonAttachImage.size.width, 0, 0)];
        self.compliantTitleTextField.rightView = attachButton;
        self.compliantTitleTextField.rightViewMode = UITextFieldViewModeAlways;
        self.compliantTitleTextField.leftView = nil;
    }
}

- (void)configureCell:(UITableViewCell *)cell
{
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.size.height + 1, cell.frame.size.width, cell.frame.size.height)];
    selectedView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:selectedView];
}

- (void)addSendButtonToNavigationBar
{
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:dynamicLocalizedString(@"compliantViewController.compliantSendBarButtonItem.title") style:UIBarButtonItemStyleDone target:self action:@selector(compliantSend:)];
    UIFont *font;
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        font = [UIFont droidKufiBoldFontForSize:14];
    } else {
        font = [UIFont latoBoldWithSize:14];
   }
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:font};
    [sendBarButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
}

@end
