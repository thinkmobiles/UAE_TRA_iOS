//
//  CheckDomainViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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

@property (weak, nonatomic) IBOutlet LeftInsetTextField *domainNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *avaliabilityButton;
@property (weak, nonatomic) IBOutlet UIButton *whoISButton;
@property (weak, nonatomic) IBOutlet UILabel *domainAvaliabilityLabel;

@property (weak, nonatomic) IBOutlet ServiceView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *topHolderView;

@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIImage *navigationBarBackgroundImage;

@end

@implementation CheckDomainViewController

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareTopView];
    [self prepareRatingView];
    [self updateNavigationControllerBar];
    [self prepareUI];
    [self displayDataIfNeeded];
    
    self.navigationBarBackgroundImage = self.navigationController.navigationBar.backIndicatorImage;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.response = nil;
    self.result = nil;
    self.domainAvaliabilityLabel.hidden = YES;
    self.ratingView.hidden = YES;
    self.domainNameTextField.text = @"";

    [self.navigationController.navigationBar setBackgroundImage:self.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];

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
    } else {
        self.domainAvaliabilityLabel.hidden = NO;
        [AppHelper showLoader];
        [self.view endEditing:YES];
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainAvaliability:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                PresentResult(response);
            }
            [AppHelper hideLoader];
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
        self.domainAvaliabilityLabel.hidden = NO;
        [AppHelper showLoader];
        [self.view endEditing:YES];
        [[NetworkManager sharedManager] traSSNoCRMServiceGetDomainData:self.domainNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:((NSString *)response).length ? response : error.localizedDescription];
            } else {
                PresentResult(response);
            }
            [AppHelper hideLoader];
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

#pragma mark - RatingViewDelegate

- (void)ratingChanged:(NSInteger)rating
{
    
}

#pragma mark - SuperclassMethods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"checkDomainViewController.title");
    self.domainNameTextField.placeholder = dynamicLocalizedString(@"checkDomainViewController.domainNameTextField");
    [self.avaliabilityButton setTitle:dynamicLocalizedString(@"checkDomainViewController.avaliabilityButton.title") forState:UIControlStateNormal];
    [self.whoISButton setTitle:dynamicLocalizedString(@"checkDomainViewController.whoISButton.title") forState:UIControlStateNormal];
    self.serviceView.serviceName.text = dynamicLocalizedString(@"checkDomainViewController.domainTitleForView");
    self.ratingView.chooseRating.text = [dynamicLocalizedString(@"checkDomainViewController.chooseRating") uppercaseString];
}

- (void)updateColors
{
    [super updateColors];
    
    self.ratingView.chooseRating.textColor = [[DynamicUIService service] currentApplicationColor];
    
    UIImage *background = [UIImage imageNamed:@"trimmedBackground"];
    if ([DynamicUIService service].colorScheme == ApplicationColorBlackAndWhite) {
        background = [[BlackWhiteConverter sharedManager] convertedBlackAndWhiteImage:background];
    }
    self.backgroundImageView.image = background;
}

#pragma mark - Private

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

- (void)prepareUI
{
    self.domainNameTextField.layer.borderColor = [UIColor lightGrayBorderColor].CGColor;
    self.domainNameTextField.layer.borderWidth = 1.5f;
    self.domainNameTextField.layer.cornerRadius = 3.f;
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
        self.ratingView.hidden = NO;
        self.avaliabilityButton.hidden = YES;
        self.whoISButton.hidden = YES;
    } else if (self.result) {
        self.ratingView.hidden = NO;
        self.tableView.hidden = NO;
        self.avaliabilityButton.hidden = YES;
        self.whoISButton.hidden = YES;
        self.domainNameTextField.hidden = YES;
    }
}

- (void)prepareRatingView
{
    self.ratingView.delegate = self;
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

@end
