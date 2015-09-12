//
//  EditUserProfileViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 10.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "EditUserProfileViewController.h"
#import "ServicesSelectTableViewCell.h"
#import "KeychainStorage.h"
#import "TextFieldNavigator.h"

static CGFloat const DefaultHeightForTableView = 26.f;

@interface EditUserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *emiratesLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;

@property (weak, nonatomic) IBOutlet UITextField *firstNmaeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTextfield;

@property (weak, nonatomic) IBOutlet UserProfileActionView *userActionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (strong, nonatomic) NSArray *dataSource;
@property (assign, nonatomic) CGPoint textFieldTouchPoint;
@property (strong, nonatomic) NSString *selectedEmirate;

@property (strong, nonatomic) ServicesSelectTableViewCell *headerCell;

@end

@implementation EditUserProfileViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareUI];
    [self fillData];
    [self prepareNotification];
}

- (void)dealloc
{
    [self removeNotifications];
}

#pragma mark - IBActions

- (IBAction)changePhotoButtonTapped:(id)sender
{
    
}

#pragma mark - UserProfileActionViewDelegate

- (void)buttonCancelDidTapped
{
    [self fillData];
}

- (void)buttonResetDidTapped
{
    self.firstNmaeTextfield.text = @"";
    self.lastNameTextField.text = @"";
    self.streetAddressTextfield.text = @"";
    self.selectedEmirate = @"";
    self.contactNumberTextfield.text = @"";
    
    [self.tableView reloadData];
}

- (void)buttonSaveDidTapped
{
    [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.notImplemented")];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServicesSelectTableViewCell *selectionCell;
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        selectionCell = [tableView dequeueReusableCellWithIdentifier:selectProviderCellArabicUIIdentifier forIndexPath:indexPath];
    } else {
        selectionCell = [tableView dequeueReusableCellWithIdentifier:selectProviderCellEuropeUIIdentifier forIndexPath:indexPath];
    }
    [self configureCell:selectionCell atIndexPath:indexPath];
    return selectionCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DefaultHeightForTableView * 1.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DefaultHeightForTableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
    [self.view endEditing:YES];
    
    self.selectedEmirate = self.dataSource[indexPath.row + 1];
    [self.tableView reloadData];

    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableViewHeightConstraint.constant = DefaultHeightForTableView;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf.tableView reloadData];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ServicesSelectTableViewCell *selectionCell;
    if ([DynamicUIService service].language == LanguageTypeArabic) {
        selectionCell = [tableView dequeueReusableCellWithIdentifier:selectProviderCellArabicUIIdentifier];
    } else {
        selectionCell = [tableView dequeueReusableCellWithIdentifier:selectProviderCellEuropeUIIdentifier];
    }
    selectionCell.selectProviderImage.tintColor = [[DynamicUIService service] currentApplicationColor];
    selectionCell.selectProviderImage.image = [UIImage imageNamed:@"selectTableDn"];
    
    if (self.selectedEmirate.length) {
        selectionCell.selectProviderLabel.text = self.selectedEmirate;
        selectionCell.selectProviderLabel.textColor = [UIColor blackColor];
    } else {
        selectionCell.selectProviderLabel.text = [self.dataSource firstObject];
        selectionCell.selectProviderLabel.textColor = [UIColor grayBorderTextFieldTextColor];
    }
    selectionCell.contentView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hederClicked)];
    tapGesture.cancelsTouchesInView = NO;
    [selectionCell.contentView addGestureRecognizer:tapGesture];
    
    self.headerCell = selectionCell;
    
    return selectionCell;
}

- (void)hederClicked
{
    [self.view endEditing:YES];
    
    NSInteger value = DefaultHeightForTableView;

    if (self.tableViewHeightConstraint.constant == DefaultHeightForTableView) {
        value *= 4;
        self.headerCell.selectProviderImage.image = [UIImage imageNamed:@"selectTableUp"];
    } else {
        self.headerCell.selectProviderImage.image = [UIImage imageNamed:@"selectTableDn"];
    }
    
    [self.view layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableViewHeightConstraint.constant = value;
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)configureCell:(ServicesSelectTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectProviderLabel.text = self.dataSource[indexPath.row + 1];
    cell.selectProviderLabel.textColor = [[DynamicUIService service] currentApplicationColor];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldTouchPoint = [textField convertPoint:textField.center toView:self.view];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [TextFieldNavigator findNextTextFieldFromCurrent:textField];
    if (textField.returnKeyType == UIReturnKeyDone) {
        __weak typeof(self) weakSelf = self;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.scrollView.contentOffset = CGPointZero;
            [weakSelf.view layoutIfNeeded];
        }];
        return YES;
    } else if (textField.returnKeyType == UIReturnKeyNext){
        __weak typeof(self) weakSelf = self;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat deltaSpace = textField.tag == 2 ? 80.f : 40.f;
            CGFloat yOffset = weakSelf.scrollView.contentOffset.y + deltaSpace;
            weakSelf.scrollView.contentOffset = CGPointMake(0, yOffset);
            [weakSelf.view layoutIfNeeded];
        }];
    }
    return NO;
}

#pragma mark - Keyboard

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat touchInViewY = self.textFieldTouchPoint.y;
    CGFloat keyboardOriginY = screenHeight - keyboardHeight;
    
    if (touchInViewY > keyboardOriginY) {
        CGFloat offsetY = keyboardOriginY - touchInViewY;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, - offsetY / 2)];
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"userProfile.title");

    self.emiratesLabel.text = dynamicLocalizedString(@"editUserProfileViewController.emiratesLabel");
    self.contactNumberLabel.text = dynamicLocalizedString(@"editUserProfileViewController.contactnumberLabel");
    self.firstNameLabel.text = dynamicLocalizedString(@"editUserProfileViewController.firstNameLabel");
    self.lastNameLabel.text = dynamicLocalizedString(@"editUserProfileViewController.lastNameLabel");
    self.streetAddressLabel.text = dynamicLocalizedString(@"editUserProfileViewController.streetAddressLabel");
    [self.changePhotoButton setTitle:dynamicLocalizedString(@"editUserProfileViewController.changePhotoButtonTitle") forState:UIControlStateNormal];
    
    [self prepareDataSource];
    [self.tableView reloadData];
}

- (void)updateColors
{
    UIImage *backgroundImage = [UIImage imageNamed:@"fav_back_orange"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        backgroundImage = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:backgroundImage];
    }
    self.backgroundImageView.image = backgroundImage;
    [self addHexagonBorderForLayer:self.logoImageView.layer color:[UIColor whiteColor]];
}

- (void)setRTLArabicUI
{
    [self updateUIaligment:NSTextAlignmentRight];

    [self.userActionView setRTLStyle];
}

- (void)setLTREuropeUI
{
    [self updateUIaligment:NSTextAlignmentLeft];
    
    [self.userActionView setLTRStyle];
}

#pragma mark - Private

- (void)updateUIaligment:(NSTextAlignment)aligment
{
    self.emiratesLabel.textAlignment = aligment;
    self.contactNumberLabel.textAlignment = aligment;
    self.firstNameLabel.textAlignment = aligment;
    self.lastNameLabel.textAlignment = aligment;
    self.streetAddressLabel.textAlignment = aligment;
    self.firstNmaeTextfield.textAlignment = aligment;
    self.lastNameTextField.textAlignment = aligment;
    self.streetAddressTextfield.textAlignment = aligment;
    self.contactNumberTextfield.textAlignment = aligment;
}

- (void)prepareDataSource
{
    self.dataSource = @[
                        dynamicLocalizedString(@"editUserProfileViewController.dataSource.0element"),
                        dynamicLocalizedString(@"state.Abu.Dhabi"),
                        dynamicLocalizedString(@"state.Ajman"),
                        dynamicLocalizedString(@"state.Dubai"),
                        dynamicLocalizedString(@"state.Fujairah"),
                        dynamicLocalizedString(@"state.Ras"),
                        dynamicLocalizedString(@"state.Sharjan"),
                        dynamicLocalizedString(@"state.Quwain")
                        ];
}

- (void)prepareUI
{
    self.userActionView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"test"];
    [self addHexagoneOnView:self.logoImageView];
}

- (void)fillData
{
    self.firstNmaeTextfield.text = [KeychainStorage userName];
}

#pragma mark - Drawing

- (void)addHexagoneOnView:(UIView *)view
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.layer.bounds;
    maskLayer.path = [AppHelper hexagonPathForView:view].CGPath;
    view.layer.mask = maskLayer;
}

- (void)addHexagonBorderForLayer:(CALayer *)layer color:(UIColor *)color
{
    CAShapeLayer *borderlayer = [CAShapeLayer layer];
    borderlayer.fillColor = [UIColor clearColor].CGColor;
    borderlayer.strokeColor = color ? color.CGColor : [[DynamicUIService service] currentApplicationColor].CGColor;
    borderlayer.lineWidth = 3.f;
    borderlayer.frame = layer.bounds;
    borderlayer.path = [AppHelper hexagonPathForRect:layer.bounds].CGPath;
    
    [layer addSublayer:borderlayer];
}

@end