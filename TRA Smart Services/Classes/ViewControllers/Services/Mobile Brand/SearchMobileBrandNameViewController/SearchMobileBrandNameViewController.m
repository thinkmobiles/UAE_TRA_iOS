//
//  SearchMobileBrandNameViewController.m
//  TRA Smart Services
//
//  Created by Admin on 25.08.15.
//

#import "SearchMobileBrandNameViewController.h"

#import "ListOfDevicesViewController.h"

static NSString *const ListDeviceSegue = @"listOfDevicesSegue";

@interface SearchMobileBrandNameViewController ()

@property (weak, nonatomic) IBOutlet BottomBorderTextField *brandNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SearchMobileBrandNameViewController

#pragma mark - IBActions

- (IBAction)searchButtonTapped:(id)sender
{
    if (self.brandNameTextField.text.length) {
        [self.view endEditing:YES];
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] traSSNoCRMServicePerformSearchByMobileBrand:self.brandNameTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
            } else {
                [loader dismissTRALoader];
                [weakSelf performSegueWithIdentifier:ListDeviceSegue sender:response];
            }
        }];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ListDeviceSegue]) {
        ListOfDevicesViewController *cont = segue.destinationViewController;
        cont.dataSource = sender;
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
    self.title = dynamicLocalizedString(@"searchMobileBrandNameViewController.title");
    [self.searchButton setTitle:dynamicLocalizedString(@"searchMobileBrandNameViewController.searchButton") forState:UIControlStateNormal];
    self.brandNameTextField.placeholder = dynamicLocalizedString(@"searchMobileBrandNameViewController.searchTextField.placeholder");
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

- (void)prepareUI
{
    self.searchButton.layer.cornerRadius = 8;
    self.searchButton.layer.borderWidth = 1;
}

- (void)updateUIElementsWithTextAlignment:(NSTextAlignment)alignment
{
    self.brandNameTextField.textAlignment = alignment;
}

@end