//
//  CheckIMEIViewController.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 13.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "CheckIMEIViewController.h"

@interface CheckIMEIViewController ()

@property (weak, nonatomic) IBOutlet UIView *barcodeView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *resultTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerPositionForTextFieldConstraint;

@property (strong, nonatomic) BarcodeCodeReader *reader;
@property (strong, nonatomic) UIImage *navigationBarImage;

@end

@implementation CheckIMEIViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reader = [[BarcodeCodeReader alloc] initWithView:self.barcodeView];
    self.reader.delegate = self;
    [self prepareUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.reader relayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.needTransparentNavigationBar) {
        self.navigationBarImage = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    } else {
        self.title = @"Check IMEI";
    }
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self registerForKeyboardNotifications];
    
    [self.reader startStopReading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.reader startStopReading];
    [self unregisterForKeyboardNotification];
    if (self.needTransparentNavigationBar) {
        [self.navigationController.navigationBar setBackgroundImage:self.navigationBarImage forBarMetrics:UIBarMetricsDefault];
    }
    self.title = @" ";
}

#pragma mark - BarcodeCodeReaderDelegate

- (void)readerDidFinishCapturingWithResult:(NSString *)result
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.resultTextField.text = result;
    });
}

#pragma mark - IBActions

- (IBAction)checkButtonTapped:(id)sender
{
    if (self.resultTextField.text.length) {
        self.resultTextField.text = @"";
        [AppHelper showLoader];
        [self endEditing];
        [[NetworkManager sharedManager] traSSNoCRMServicePerformSearchByIMEI:self.resultTextField.text requestResult:^(id response, NSError *error) {
            if (error) {
                [AppHelper alertViewWithMessage:error.localizedDescription];
            } else {
                //todo
            }
            [AppHelper hideLoader];
        }];
    } else {
        [AppHelper alertViewWithMessage:MessageEmptyInputParameter];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scanIMEISegue"]) {
        CheckIMEIViewController *viewController = segue.destinationViewController;
        viewController.needTransparentNavigationBar = YES;
    }
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)unregisterForKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboadWillShow:(NSNotification*)notification
{
    CGRect screen = [UIScreen mainScreen].bounds;
    CGRect keyboard = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if (CGRectGetMaxY(self.contentView.frame) > (CGRectGetHeight(screen) - CGRectGetHeight(keyboard))) {
        CGPoint offset = CGPointMake(0.f,  CGRectGetMaxY(screen) - (CGRectGetHeight(keyboard) + CGRectGetMaxY(self.contentView.frame)));
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25f animations:^{
            self.centerPositionForTextFieldConstraint.constant += offset.y;
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing];
    return YES;
}

#pragma mark - Private

- (void)prepareUI
{
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[UIButton class]] && !subView.tag) {
            subView.layer.cornerRadius = 8;
            subView.layer.borderColor = [UIColor defaultOrangeColor].CGColor;
            subView.layer.borderWidth = 1;
        }
    }
    
    self.contentView.layer.cornerRadius = 8;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)endEditing
{
    [self.view endEditing:YES];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.centerPositionForTextFieldConstraint.constant = 100;
        [self.view layoutIfNeeded];
    }];
}

@end
