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
static CGFloat const heightSelectTableViewCell = 40;
static CGFloat const verticalSpaceDescriptionConstraintCompliantCustomServise = 134.f;
static CGFloat const verticalSpaceDescriptionConstraintCompliantServise = 18.f;
static CGFloat const verticalSpaceTitleConstraint = 33.f;

@interface CompliantViewController ()

@property (weak, nonatomic) IBOutlet LeftInsetTextField *compliantTitle;
@property (weak, nonatomic) IBOutlet LeftInsetTextField *refNumber;
@property (weak, nonatomic) IBOutlet UIButton *compliantButton;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *compliantDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceTitleTextFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceDescriptionConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet ServiceView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *topHolderView;
@property (strong, nonatomic) UIImage *navigationBarBackgroundImage;
@property (strong, nonatomic) NSArray *selectProviderDataSource;
@property (strong, nonatomic) NSString *selectProvider;

@end

@implementation CompliantViewController

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUIForCompliantType:self.type];
    [self prepareSelectProviderDataSource];
    self.selectProvider = @"";
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

- (IBAction)compliant:(id)sender
{
    [self.view endEditing:YES];
    if (!self.compliantDescriptionTextView.text.length ||
        !self.compliantTitle.text.length ||
        (self.type == ComplianTypeCustomProvider && (!self.selectProvider.length || !self.refNumber.text.length))){
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        [AppHelper showLoader];
        [[NetworkManager sharedManager] traSSNoCRMServicePOSTComplianAboutServiceProvider:self.selectProvider title:self.compliantTitle.text description:self.compliantDescriptionTextView.text refNumber:[self.refNumber.text integerValue] attachment:self.selectImage complienType:self.type requestResult:^(id response, NSError *error) {
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
    if (indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:providerCellIdentifier];
        cell.textLabel.text = self.selectProviderDataSource[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [self configureCell:cell];
        return cell;
    } else {
        ServicesSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectProviderCellIdentifier forIndexPath:indexPath];
        cell.selectProviderLabel.textColor = [UIColor whiteColor];
        if (self.heightTableViewConstraint.constant == heightSelectTableViewCell) {
            cell.selectProviderImage.image = [UIImage imageNamed:@"selectTableDn"];
        } else {
            cell.selectProviderImage.image = [UIImage imageNamed:@"selectTableUp"];
        }
        if (self.selectProvider.length) {
            cell.selectProviderLabel.text = self.selectProvider;
        } else {
            cell.selectProviderLabel.text = self.selectProviderDataSource[indexPath.row];
        }
        [self configureCell:cell];
        return cell;
    }
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
    if (self.heightTableViewConstraint.constant == heightSelectTableViewCell) {
        [self animationSelectTableView:YES];
        [self.compliantTitle resignFirstResponder];
    } else {
        [self animationSelectTableView:NO];
        if (indexPath.row) {
            
            self.selectProvider = self.selectProviderDataSource[indexPath.row];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self scrollingToVizibleView:textField];
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
    [self scrollingToVizibleView:textView];
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"compliantViewController.title");
    self.compliantTitle.placeholder = dynamicLocalizedString(@"compliantViewController.textField.compliantTitle");
    self.refNumber.placeholder = dynamicLocalizedString(@"compliantViewController.textField.refNumber");
    self.compliantDescriptionTextView.placeholder = dynamicLocalizedString(@"compliantViewController.descriptionLabel.text");
    [self.compliantButton setTitle:dynamicLocalizedString(@"compliantViewController.compliantButton.title") forState:UIControlStateNormal];
    [self prepareSelectProviderDataSource];
    [self.selectTableView reloadData];
}

- (void)updateColors
{
    [super updateColors];
    
    [AppHelper setStyleGrayColorForLayer:self.compliantDescriptionTextView.layer];
    [AppHelper setStyleGrayColorForLayer:self.selectTableView.layer];
    self.selectTableView.backgroundColor = [[DynamicUIService service] currentApplicationColor];
}
#pragma mark - Keyboard

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDissappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            self.selectTableView.hidden = NO;
            self.refNumber.hidden = NO;
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
    self.selectProviderDataSource = @[dynamicLocalizedString(@"compliantViewController.textField.providerText"),
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
        [weakSelf.view layoutIfNeeded];
    }];
    [self.selectTableView reloadData];
}

- (void)addAttachButtonTitleTextField
{
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachButton setImage:[UIImage imageNamed:@"attach11"] forState:UIControlStateNormal];
    [attachButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    attachButton.backgroundColor = [UIColor clearColor];
    attachButton.tintColor = [[DynamicUIService service] currentApplicationColor];
    [attachButton setFrame:CGRectMake(0, 0, self.compliantTitle.frame.size.height, self.compliantTitle.frame.size.height)];
    attachButton.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    attachButton.layer.borderWidth = 0;
    self.compliantTitle.rightView = attachButton;
    self.compliantTitle.rightViewMode = UITextFieldViewModeAlways;
}

- (void)scrollingToVizibleView:(UIView *)view
{
    [self.scrollView setContentOffset:CGPointMake(0, view.frame.origin.y - verticalSpaceTitleConstraint) animated:YES];

}

- (void)configureCell:(UITableViewCell *)cell
{
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.size.height + 1, cell.frame.size.width, cell.frame.size.height)];
    selectedView.backgroundColor = [UIColor clearColor];
    UIView *separatovView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, cell.bounds.size.width, 0.5f)];
    separatovView.backgroundColor = [UIColor grayBorderTextFieldTextColor];
    [selectedView addSubview:separatovView];
    [cell setSelectedBackgroundView:selectedView];
}

@end
