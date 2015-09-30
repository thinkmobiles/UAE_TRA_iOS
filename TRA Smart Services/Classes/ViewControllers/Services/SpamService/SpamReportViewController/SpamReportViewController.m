//
//  SpamRaportViewController.m
//  TRA Smart Services
//
//  Created by Admin on 13.08.15.
//

#import "SpamReportViewController.h"
#import "NetworkManager.h"
#import "LoginViewController.h"
#import "ServicesSelectTableViewCell.h"
#import "PlaceholderTextView.h"

static NSInteger const BlockServiceNumber = 7726;
static CGFloat const heightSelectTableViewCell = 40.f;
static CGFloat const verticalTopReportTextFieldConstreintSpamSMS = 96.f;
static CGFloat const verticalTopReportTextFieldConstreintSpamWeb = 20.f;

@interface SpamReportViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *reportTextField;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTableViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalTopReportTextFieldConstreint;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (weak, nonatomic) IBOutlet UIView *separatorDescription;
@property (weak, nonatomic) IBOutlet UIView *separatorSelectedProvider;

@property (strong, nonatomic) NSArray *selectProviderDataSource;
@property (strong, nonatomic) NSString *selectedProvider;

@end

@implementation SpamReportViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedProvider = @"";
    self.reportButton.layer.cornerRadius = 5.f;

    [self prepareDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self didChangeReportType:self.selectSpamReport];
    [self configureTextField];
}

#pragma mark - IBAction

- (IBAction)responseSpam:(id)sender
{
    [self.view endEditing:YES];
    if (self.selectSpamReport == SpamReportTypeWeb) {
        if (!self.reportTextField.text.length) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        }  else  if (![self.reportTextField.text isValidURL]) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatURL")];
        } else {
            [self helpSalimReport];
        }
    } else if (self.selectSpamReport == SpamReportTypeSMS) {
        if (!self.reportTextField.text.length || !self.selectedProvider.length || !self.descriptionTextView.text.length) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
        } else {
            [self POSTSpamReport];
            [self sendSMSMessage];
        }
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
            cell.selectProviderLabel.textColor = [self.dynamicService currentApplicationColor];
        } else {
            cell.selectProviderLabel.text = self.selectProviderDataSource[indexPath.row];
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

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(self.selectSpamReport == SpamReportTypeSMS ? @"spamReportViewControler.title.spamSMS" : @"spamReportViewControler.title.spamWEB");
    self.reportTextField.placeholder = dynamicLocalizedString(self.selectSpamReport == SpamReportTypeSMS ?@"spamReportViewControler.reportTextField.reportSMS" : @"spamReportViewControler.reportTextField.reportWeb");
    [self.reportButton setTitle:dynamicLocalizedString(@"spamReportViewControler.reportButton.title") forState:UIControlStateNormal];
    self.descriptionTextView.placeholder = dynamicLocalizedString(@"spamReportViewControler.descriptionTextView.placeholder");
}

- (void)updateColors
{
    [super updateColors];
    
    UIColor *color = [self.dynamicService currentApplicationColor];
    
    self.reportButton.backgroundColor = color;
    self.descriptionTextView.textColor = color;
    self.reportTextField.textColor = color;
    self.separatorDescription.backgroundColor = color;
    self.separatorSelectedProvider.backgroundColor = color;
    [super updateBackgroundImageNamed:@"img_bg_service"];
    [self.selectTableView reloadData];
    [self.reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AppHelper setStyleForTextView:self.descriptionTextView];
}

- (void)setRTLArabicUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];
}

#pragma mark - Networking

- (void)helpSalimReport
{
    [self.view endEditing:YES];
    TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTHelpSalim:self.reportTextField.text notes:self.descriptionTextView.text requestResult:^(id response, NSError *error) {
        if (error) {
            [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
        } else {
            [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
        }
    }];
}

- (void)POSTSpamReport
{
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSSpamReport:self.reportTextField.text notes:self.descriptionTextView.text requestResult:^(id response, NSError *error) {
    }];
}

- (void)POSTSMSBlock
{
    [[NetworkManager sharedManager] traSSNoCRMServicePOSTSMSBlock:self.reportTextField.text phoneProvider:[NSString stringWithFormat:@"%i", (int)BlockServiceNumber] providerType:self.selectedProvider notes:self.descriptionTextView.text requestResult:^(id response, NSError *error) {
    }];
}

#pragma mark - SMSMessage

- (void)sendSMSMessage
{
    if([MFMessageComposeViewController canSendText]) {
        [UINavigationBar appearance].barTintColor = self.dynamicService.currentApplicationColor;
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName : self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:17] : [UIFont latoRegularWithSize:17]};
        
        NSArray *recipents = @[[NSString stringWithFormat:@"%i", (int)BlockServiceNumber]];
        NSString *message = [NSString stringWithFormat:@"b %@", self.reportTextField.text];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
        [messageController setBody:message];
        [self presentViewController:messageController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
        messageController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.FailedToInitializeMFController")];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultFailed: {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.FailedToSendSMS")];
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)configureTextField
{
    UIImage *image = [UIImage imageNamed:self.selectSpamReport == SpamReportTypeSMS ? @"ic_phone_spam" : @"ic_www"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setImage:image];
    imageView.tintColor = [self.dynamicService currentApplicationColor];
    self.reportTextField.rightView = nil;
    self.reportTextField.leftView = nil;
    if (self.dynamicService.language == LanguageTypeArabic) {
        self.reportTextField.leftViewMode = UITextFieldViewModeAlways;
        self.reportTextField.leftView = imageView;
    } else {
        self.reportTextField.rightViewMode = UITextFieldViewModeAlways;
        self.reportTextField.rightView = imageView;
    }
}

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.descriptionTextView.textAlignment = alignment;
    self.reportTextField.textAlignment = alignment;
    [self.descriptionTextView setNeedsDisplay];
}

- (void)didChangeReportType:(SpamReportType)select
{
    if (select == SpamReportTypeWeb) {
        self.selectTableView.hidden = YES;
        self.separatorSelectedProvider.hidden = YES;
        self.verticalTopReportTextFieldConstreint.constant = verticalTopReportTextFieldConstreintSpamWeb;
    } else {
        [self presentLoginIfNeededAndPopToRootController:[self.navigationController viewControllers][self.navigationController.viewControllers.count - 2]];
        self.selectTableView.hidden = NO;
        self.separatorSelectedProvider.hidden = NO;
        self.verticalTopReportTextFieldConstreint.constant = verticalTopReportTextFieldConstreintSpamSMS;
    }
    [self clearUp];
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
        self.verticalTopReportTextFieldConstreint.constant = verticalTopReportTextFieldConstreintSpamSMS + heightTableView - heightSelectTableViewCell;
        [weakSelf.view layoutIfNeeded];
    }];
    [self.selectTableView reloadData];
}

- (void)clearUp
{
    self.reportTextField.text = @"";
    self.descriptionTextView.text = @"";
    self.selectedProvider= @"";
}

- (void)prepareDataSource
{
    self.selectProviderDataSource = @[
                                      dynamicLocalizedString(@"providerType.selectProvider.text"),
                                      dynamicLocalizedString(@"providerType.Du"),
                                      dynamicLocalizedString(@"providerType.Etisalat"),
                                      ];
}

@end