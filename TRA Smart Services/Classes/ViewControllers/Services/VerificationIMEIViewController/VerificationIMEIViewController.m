//
//  VerificationIMEIViewController.m
//  TRA Smart Services
//
//  Created by Admin on 17.09.15.
//

#import "VerificationIMEIViewController.h"
#import "CheckIMEIViewController.h"

#import "ServiceHeaderView.h"

#import "CheckIMEIModel.h"

@interface VerificationIMEIViewController()

@property (weak, nonatomic) IBOutlet ServiceHeaderView *conteinerServiseHeaderView;
@property (weak, nonatomic) IBOutlet BottomBorderTextField *verificationIMEITextField;
@property (weak, nonatomic) IBOutlet UILabel *verificationIMEIInfoEnterLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendIMEICodeButton;
@property (weak, nonatomic) IBOutlet UILabel *sendIMEICodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultSendIMEILabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation VerificationIMEIViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self prepareServiseHeaderView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.title = @" ";
}

#pragma mark - IBAction

- (IBAction)checkButtonTapped:(id)sender
{
    if (self.verificationIMEITextField.text.length) {
        [self.view endEditing:YES];
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSNoCRMServicePerformSearchByIMEI:self.verificationIMEITextField.text requestResult:^(id response, NSError *error) {
            if ([response isKindOfClass:[NSArray class]] && !error) {
                NSString *resultIMEI = @"";
                for (NSDictionary *dic in response) {
                    CheckIMEIModel *obj = [[CheckIMEIModel alloc] initFromDictionary:dic];
                    resultIMEI = [resultIMEI stringByAppendingString:obj.description];
                }
                [self showResultSendIMEI:resultIMEI];
                [loader dismissTRALoader];
            } else {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
            }
        }];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scanIMEISegue"]) {
        CheckIMEIViewController *viewController = segue.destinationViewController;
        viewController.needTransparentNavigationBar = YES;
        viewController.hidesBottomBarWhenPushed = YES;
        __weak typeof(self) weakSelf = self;
        viewController.didFinishWithResult = ^(NSString *result) {
            weakSelf.verificationIMEITextField.text = result;
        };
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"verificationIMEIViewController.title");
    self.verificationIMEITextField.placeholder = dynamicLocalizedString(@"verificationIMEIViewController.verificationIMEITextField.placeholder");;
    self.verificationIMEIInfoEnterLabel.text = dynamicLocalizedString(@"verificationIMEIViewController.verificationIMEIInfoEnterLabel");;
    self.sendIMEICodeLabel.text = dynamicLocalizedString(@"verificationIMEIViewController.sendIMEICodeLabel");
}

- (void)updateColors
{
    [self.conteinerServiseHeaderView updateUIColor];
    [AppHelper setStyleForTextField:self.verificationIMEITextField];
    [super updateBackgroundImageNamed:@"img_bg_service"];
    
    UIColor *color = [UIColor defaultGreenColor];
    if (self.dynamicService.colorScheme == ApplicationColorBlackAndWhite) {
        color = [UIColor blackColor];
    }
    self.sendIMEICodeLabel.textColor = color;
    self.sendIMEICodeButton.tintColor = color;
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

#pragma mark - Private

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.verificationIMEITextField.textAlignment = alignment;
    [self configureTextField:self.verificationIMEITextField];
}

- (void)prepareForSegue
{
    [self performSegueWithIdentifier:@"scanIMEISegue" sender:self];
}

- (void)configureTextField:(UITextField *)textField
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateSelected];
    [button setTintColor:[self.dynamicService currentApplicationColor]];
    [button addTarget:self action:@selector(prepareForSegue) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = nil;
    textField.leftView = nil;
    if (self.dynamicService.language == LanguageTypeArabic) {
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = button;
    } else {
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = button;
    }
}

- (void)prepareServiseHeaderView
{
    self.conteinerServiseHeaderView.serviceHeaderLabel.text = dynamicLocalizedString(@"verificationIMEIViewController.serviceHeaderLabel");
    self.conteinerServiseHeaderView.serviceHeaderLabel.textColor = [UIColor blackColor];
    self.conteinerServiseHeaderView.serviceHeaderLabel.font = self.dynamicService.language == LanguageTypeArabic ? [UIFont droidKufiRegularFontForSize:16] : [UIFont latoRegularWithSize:16];
    self.conteinerServiseHeaderView.serviceHeaderImage = [UIImage imageNamed:@"ic_mobile"];
}

- (void)showResultSendIMEI:(NSString *)result
{
    self.containerView.hidden = YES;
    self.resultSendIMEILabel.hidden = NO;
    self.resultSendIMEILabel.text = result;
}

@end