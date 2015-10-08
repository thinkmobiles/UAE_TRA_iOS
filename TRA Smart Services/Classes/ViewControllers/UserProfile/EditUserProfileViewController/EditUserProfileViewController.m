//
//  EditUserProfileViewController.m
//  TRA Smart Services
//
//  Created by Admin on 10.09.15.
//

#import "EditUserProfileViewController.h"

#import "ServicesSelectTableViewCell.h"
#import "KeychainStorage.h"
#import "TextFieldNavigator.h"

@interface EditUserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UserProfileActionView *userActionView;

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
    //waint design
}

#pragma mark - UserProfileActionViewDelegate

- (void)buttonCancelDidTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonResetDidTapped
{
    [self fillData];
}

- (void)buttonSaveDidTapped
{
    if (self.firstNameTextfield.text.length && self.lastNameTextField.text.length) {
       
        if ((self.firstNameTextfield.text.length > 32) || (self.lastNameTextField.text.length > 32)) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatTooLong")];
            return;
        } else if ((self.firstNameTextfield.text.length < 3) || (self.lastNameTextField.text.length < 3)) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatTooShort")];
            return;
        }
        
        if (![self.firstNameTextfield.text isValidName]){
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatFirstName")];
            return;
        } else if (![self.lastNameTextField.text isValidName]) {
            [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.InvalidFormatLastName")];
            return;
        }
        
        UserModel *user = [[UserModel alloc] initWithFirstName:self.firstNameTextfield.text lastName:self.lastNameTextField.text streetName:@"" contactNumber:@""];
        
        TRALoaderViewController *loader = [TRALoaderViewController presentLoaderOnViewController:self requestName:self.title closeButton:NO];
        [[NetworkManager sharedManager] traSSUpdateUserProfile:user requestResult:^(id response, NSError *error) {
            if (error || ![response isKindOfClass:[NSDictionary class]]) {
                [loader setCompletedStatus:TRACompleteStatusFailure withDescription:dynamicLocalizedString(@"api.message.serverError")];
            } else {
                UserModel *updateUser = [[UserModel alloc] initWithDictionary:response];
                [[KeychainStorage new] saveCustomObject:updateUser key:userModelKey];
                [loader setCompletedStatus:TRACompleteStatusSuccess withDescription:nil];
            }
        }];
    } else {
        [AppHelper alertViewWithMessage:dynamicLocalizedString(@"message.EmptyInputParameters")];
    }
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
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.scrollView.contentOffset = CGPointZero;
        }];
        return YES;
    } else if (textField.returnKeyType == UIReturnKeyNext){
        __weak typeof(self) weakSelf = self;
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat deltaSpace = textField.tag == 2 ? 80.f : 40.f;
            CGFloat yOffset = weakSelf.scrollView.contentOffset.y + deltaSpace;
            weakSelf.scrollView.contentOffset = CGPointMake(0, yOffset);
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
        }];
    }
}

#pragma mark - Superclass Methods

- (void)localizeUI
{
    self.title = dynamicLocalizedString(@"userProfile.title");
    [self.userActionView localizeUI];
    
    self.firstNameLabel.text = dynamicLocalizedString(@"editUserProfileViewController.firstNameLabel");
    self.lastNameLabel.text = dynamicLocalizedString(@"editUserProfileViewController.lastNameLabel");
    [self.changePhotoButton setTitle:dynamicLocalizedString(@"editUserProfileViewController.changePhotoButtonTitle") forState:UIControlStateNormal];
}

- (void)updateColors
{
    [super updateBackgroundImageNamed:@"fav_back_orange"];
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
    self.firstNameLabel.textAlignment = aligment;
    self.lastNameLabel.textAlignment = aligment;
    self.firstNameTextfield.textAlignment = aligment;
    self.lastNameTextField.textAlignment = aligment;
}

- (void)prepareUI
{
    self.userActionView.delegate = self;
    self.logoImageView.image = [UIImage imageNamed:@"ic_user_login"];
    [AppHelper addHexagoneOnView:self.logoImageView];
    [AppHelper addHexagonBorderForLayer:self.logoImageView.layer color:[UIColor whiteColor] width:3.0];
    self.logoImageView.tintColor = [UIColor whiteColor];
}

- (void)fillData
{
    UserModel *user = [[KeychainStorage new] loadCustomObjectWithKey:userModelKey];
    self.firstNameTextfield.text = user.firstName;
    self.lastNameTextField.text = user.lastName;
}

- (BOOL)isValidPhoneNumber
{
    NSString *allowedSymbols = @"[0-9]{4,}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allowedSymbols];
    return [test evaluateWithObject:self];
}

@end