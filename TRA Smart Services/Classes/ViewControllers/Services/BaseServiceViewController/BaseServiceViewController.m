//
//  BaseServiceViewController.m
//  TRA Smart Services
//
//  Created by Admin on 31.08.15.
//

#import "BaseServiceViewController.h"
#import "LoginViewController.h"

static CGFloat const HeightForToolbars = 44.f;

@interface BaseServiceViewController()

@property (weak, nonatomic)  id textView;
@property (assign, nonatomic) CGFloat keyboardHeight;

@end

@implementation BaseServiceViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [AppHelper titleFontForNavigationBar:self.navigationController.navigationBar];
    self.navigationController.navigationBar.translucent = YES;
    
    [self prepareNotification];
}

#pragma mark - Public

- (void)presentLoginIfNeededAndPopToRootController:(UIViewController *)controller
{
    if (![NetworkManager sharedManager].isUserLoggined) {
        UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        __weak typeof(self) weakSelf = self;
        ((LoginViewController *)viewController.topViewController).didCloseViewController = ^() {
            if (![NetworkManager sharedManager].isUserLoggined) {
                if (controller) {
                    [weakSelf.navigationController popToViewController:controller animated:NO];
                } else {
                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                }
            }
        };
        ((LoginViewController *)viewController.topViewController).shouldAutoCloseAfterLogin = YES;
        [AppHelper presentViewController:viewController onController:self.navigationController];
    }
}

- (void)configureKeyboardButtonDone:(id)textView
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HeightForToolbars)];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.tintColor = [[DynamicUIService service] currentApplicationColor];
    
    UIBarButtonItem *barItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:@[flexibleSpace, barItemDone]];
    
    [textView setInputAccessoryView:toolBar];
    self.textView = textView;
}

#pragma mark - TextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    CGRect frame = textView.frame;
    CGFloat curcorPointY = frame.origin.y + caretRect.origin.y - textView.contentOffset.y - HeightForToolbars;
    CGFloat keyPositionY = self.view.frame.size.height - self.keyboardHeight;
    if (curcorPointY > keyPositionY) {
        CGFloat lineKetboard = self.keyboardHeight - self.view.bounds.size.height + frame.origin.y + frame.size.height - HeightForToolbars;
        CGPoint bottomOffset = CGPointMake(0, textView.contentSize.height - frame.size.height + lineKetboard);
        [textView setContentOffset: bottomOffset];
    }
}

#pragma mark - Superclass methods

- (void)updateColors
{
    for (UILabel *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.textColor = [self.dynamicService currentApplicationColor];
        }
    }
    [self updateColors:self.view];
}

#pragma mark - Action

- (void)doneButtonTapped
{
    [self.textView resignFirstResponder];
}

#pragma mark - Private

- (void)updateColors:(UIView *) view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [(UIButton *)subView setBackgroundColor:[self.dynamicService currentApplicationColor]];
        } else if ([subView isKindOfClass:[BottomBorderTextField class]]) {
            [AppHelper setStyleForTextField:(BottomBorderTextField *)subView];
        }  else if ([subView isKindOfClass:[BottomBorderTextView class]]) {
            [AppHelper setStyleForTextView:(BottomBorderTextView *)subView];
        }
        [self updateColors:subView];
    }
}

#pragma mark - Keyboard

- (void)prepareNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.textView setContentOffset: CGPointZero];
}

@end
