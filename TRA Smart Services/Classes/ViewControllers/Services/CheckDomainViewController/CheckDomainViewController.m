//
//  CheckDomainViewController.m
//  TRA Smart Services
//
//  Created by Admin on 13.08.15.
//

#import "CheckDomainViewController.h"
#import "ServiceView.h"
#import "UINavigationController+Transparent.h"
#import "UIImage+DrawText.h"
#import "LeftInsetTextField.h"
#import "DomainInfoTableViewCell.h"

static NSString *const Keykey = @"key";
static NSString *const keyValue = @"value";
static NSString *const keyOrder = @"order";

@interface CheckDomainViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *domainNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *avaliabilityButton;
@property (weak, nonatomic) IBOutlet UIButton *whoISButton;
@property (weak, nonatomic) IBOutlet UILabel *domainAvaliabilityLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CheckDomainViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.domainName) {
        self.domainNameTextField.userInteractionEnabled = YES;
    }
    
    [self updateNavigationControllerBar];
    [self displayDataIfNeeded];
    [self prepareButtonTitle];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (!self.response) {
        self.domainAvaliabilityLabel.hidden = YES;
        self.domainNameTextField.text = @"";
    }
    if (!self.result) {
        self.tableView.hidden = YES;
    }

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[self.dynamicService currentApplicationColor] inRect:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - IBActions

- (IBAction)avaliabilityButtonTapped:(id)sender
{
    __weak typeof(self) weakSelf = self;
    void (^PresentResult)(NSString *response) = ^(NSString *response) {
        CheckDomainViewController *checkDomainViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"verificationID"];
        checkDomainViewController.response = response;
        checkDomainViewController.domainName = weakSelf.domainNameTextField.text;        
        [weakSelf.navigationController pushViewController:checkDomainViewController animated:YES];
    };
    
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else if (![self.domainNameTextField.text isValidURL]) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatURL")];
    } else {
        [self.domainNameTextField resignFirstResponder];
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainAvaliability:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
                [weakSelf displayDataIfNeeded];
            } else {
                weakSelf.domainAvaliabilityLabel.hidden = NO;
                [loader dismissTRALoader];
                PresentResult(response);
            }
        }];
    }
}

- (IBAction)whoIsButtonTapped:(id)sender
{
    __weak typeof(self) weakSelf = self;
    void (^PresentResult)(NSString *response) = ^(NSString *response) {
        NSArray *parsedData = [weakSelf parseData:response];
        CheckDomainViewController *checkDomainViewController = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"verificationID"];
        checkDomainViewController.result = parsedData;
        checkDomainViewController.domainName = weakSelf.domainNameTextField.text;
        [weakSelf.navigationController pushViewController:checkDomainViewController animated:YES];
    };
    
    if (!self.domainNameTextField.text.length) {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    } else {
        [self.domainNameTextField resignFirstResponder];
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainData:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
                [weakSelf displayDataIfNeeded];
            } else {
                weakSelf.domainAvaliabilityLabel.hidden = NO;
                [loader dismissTRALoader];
                PresentResult(response);
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DomainInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DomainInfoCompactCellIdentifier forIndexPath:indexPath];
    if (indexPath.row > 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:DomainInfoDetailsCellIdentifier forIndexPath:indexPath];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 25.f;
    if (indexPath.row > 3) {
        height = 75.f;
    }
    return height;
}

- (void)configureCell:(DomainInfoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedItem = self.result[indexPath.row];
    cell.typeLabel.text = [selectedItem valueForKey:Keykey];
    if ([[selectedItem valueForKey:keyValue] isKindOfClass:[NSArray class]]) {
        NSString *list = @"";
        for (NSString *string in  [selectedItem valueForKey:keyValue]) {
            list = [[list stringByAppendingString:string] stringByAppendingString:@"; "];
        }
        cell.valueLabel.text = list;
    } else {
        cell.valueLabel.text = [selectedItem valueForKey:keyValue];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"checkDomainViewController.title");
    self.domainNameTextField.placeholder = dynamicLocalizedString(@"checkDomainViewController.domainNameTextField");
    [self.avaliabilityButton setTitle:dynamicLocalizedString(@"checkDomainViewController.avaliabilityButton.title") forState:UIControlStateNormal];
    [self.whoISButton setTitle:dynamicLocalizedString(@"checkDomainViewController.whoISButton.title") forState:UIControlStateNormal];
}

- (void)updateColors
{
    [super updateColors];
    
    [super updateBackgroundImageNamed:@"img_bg_service"];
}

- (void)setRTLArabicUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentRight];
}

- (void)setLTREuropeUI
{
    [self updateUIElementsWithTextAlignment:NSTextAlignmentLeft];
}

#pragma mark - Private

- (void)updateNavigationControllerBar
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style: UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.domainNameTextField.textAlignment = alignment;
    self.domainAvaliabilityLabel.textAlignment = alignment;
}

- (void)displayDataIfNeeded
{
    if (self.response.length) {
        self.domainAvaliabilityLabel.hidden = NO;
        self.domainAvaliabilityLabel.text = [self.response uppercaseString];
        self.domainNameTextField.text = self.domainName;
        if ([self.response containsString:@"Not"]) {
            self.domainAvaliabilityLabel.textColor = [UIColor redTextColor];
        } else {
            self.domainAvaliabilityLabel.textColor = [UIColor lightGreenTextColor];
        }
        self.avaliabilityButton.hidden = YES;
        self.whoISButton.hidden = YES;
    } else if (self.result) {
        self.tableView.hidden = NO;
        self.avaliabilityButton.hidden = YES;
        self.whoISButton.hidden = YES;
        self.domainNameTextField.hidden = YES;
    }
}

- (NSArray *)parseData:(NSString *)inputData
{
    NSArray *values = [inputData componentsSeparatedByString:@"\r\n"];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *key;
    NSInteger i = 0;
    for (NSString *string in values) {
 
        if (string.length) {
            
            NSArray *keyValueData = [string componentsSeparatedByString:@":"];
            NSString *value = [(NSString *)[keyValueData lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            key = [(NSString *)[keyValueData firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([key isEqualToString:@"No Data Found"]) {
                key = @"Result";
            }
            NSMutableDictionary *innerDictionary = [[NSMutableDictionary alloc] init];
            [innerDictionary setValue:@(i) forKey:keyOrder];
            [innerDictionary setValue:key forKey:Keykey];
            i++;

            if ([dataDictionary valueForKey:key]) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                id innerObj = [[dataDictionary valueForKey:key] valueForKey:keyValue];
                if ([innerObj isKindOfClass:[NSArray class]]) {
                    for (id obj in (NSArray *)innerObj) {
                        [array addObject:obj];
                    }
                } else {
                    [array addObject:innerObj];
                }
                [array addObject:value];
                [innerDictionary setObject:array forKey:keyValue];
                [dataDictionary setObject:innerDictionary forKey:key];
                continue;
            }
            
            [innerDictionary setObject:value forKey:keyValue];
            [dataDictionary setObject:innerDictionary forKey:key];
        }
    }
    
    NSArray *data = [dataDictionary allValues];
    data = [data sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [[obj1 valueForKey:keyOrder] integerValue] > [[obj2 valueForKey:keyOrder] integerValue];
    }];
    
    return data;
}

- (void)prepareButtonTitle
{
    [self minimumScaleFactorTitleButton:self.whoISButton];
    [self minimumScaleFactorTitleButton:self.avaliabilityButton];
}

- (void)minimumScaleFactorTitleButton:(UIButton *)button
{
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.7f;
}

@end
