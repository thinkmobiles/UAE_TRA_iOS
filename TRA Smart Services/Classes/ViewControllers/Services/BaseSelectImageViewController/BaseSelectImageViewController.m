//
//  BaseSelectImageViewController.m
//  TRA Smart Services
//
//  Created by Admin on 14.08.15.
//

#import "BaseSelectImageViewController.h"

static NSString *const ImageNameButtonAttachClear = @"btn_attach";
static NSString *const ImageNameButtonAttachData = @"btn_attach_file";

@interface BaseSelectImageViewController ()

@property (strong, nonatomic) UIImage *buttonAttachImage;

@end

@implementation BaseSelectImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttonAttachImage = [UIImage imageNamed:ImageNameButtonAttachClear];
}

#pragma mark - Public

- (void)addAttachButtonTextField:(UITextField *)textField
{
    textField.rightView = nil;
    textField.leftView = nil;
    
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachButton setImage:self.buttonAttachImage forState:UIControlStateNormal];
    [attachButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    attachButton.backgroundColor = [UIColor clearColor];
    attachButton.tintColor = [self.dynamicService currentApplicationColor];
    [attachButton setFrame:CGRectMake(0, 0, textField.frame.size.height, textField.frame.size.height)];
    
    if (self.dynamicService.language == LanguageTypeArabic) {
        [attachButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, attachButton.frame.size.width - self.buttonAttachImage.size.width)];
        textField.leftView = attachButton;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
    } else {
        [attachButton setImageEdgeInsets:UIEdgeInsetsMake(0, attachButton.frame.size.width - self.buttonAttachImage.size.width, 0, 0)];
        textField.rightView = attachButton;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
}

#pragma mark - SelectPhoto

- (void)selectImagePickerController
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.buttonAttachImage = [UIImage imageNamed:ImageNameButtonAttachData];
}

#pragma mark - IBAction

- (IBAction)selectImage:(id)sender
{
    [self selectImagePickerController];
}

@end