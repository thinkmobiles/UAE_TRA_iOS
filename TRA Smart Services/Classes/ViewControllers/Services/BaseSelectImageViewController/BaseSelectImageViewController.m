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
@property (strong, nonatomic) UIButton *attachButton;

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
    
    self.attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.attachButton setImage:self.buttonAttachImage forState:UIControlStateNormal];
    [self.attachButton addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    self.attachButton.backgroundColor = [UIColor clearColor];
    self.attachButton.tintColor = [self.dynamicService currentApplicationColor];
    [self.attachButton setFrame:CGRectMake(0, 0, textField.frame.size.height, textField.frame.size.height)];
    
    if (self.dynamicService.language == LanguageTypeArabic) {
        textField.leftView = self.attachButton;
        textField.leftViewMode = UITextFieldViewModeAlways;
    } else {
        textField.rightView = self.attachButton;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
}

#pragma mark - Private

- (void)setButtonAttachImage:(UIImage *)buttonAttachImage
{
    _buttonAttachImage = buttonAttachImage;
    [self.attachButton setImage:self.buttonAttachImage forState:UIControlStateNormal];
}

- (void)setSelectImage:(UIImage *)selectImage
{
    _selectImage = selectImage;
    self.buttonAttachImage = selectImage ? [UIImage imageNamed:ImageNameButtonAttachData] : [UIImage imageNamed:ImageNameButtonAttachClear];
}

- (void)configureActionSheet
{
    UIAlertController *selectImageController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:dynamicLocalizedString(@"selectImageActionSheet.cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [selectImageController addAction:cancelAction];
    
    UIAlertAction *selectImageAction = [UIAlertAction actionWithTitle:dynamicLocalizedString(@"selectImageActionSheet.selectImage") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImagePickerController];
    }];
    [selectImageController addAction:selectImageAction];
    
    UIAlertAction *removeAttachAction = [UIAlertAction actionWithTitle:dynamicLocalizedString(@"selectImageActionSheet.removeFile") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.selectImage) {
            self.selectImage = nil;
            self.buttonAttachImage = [UIImage imageNamed:ImageNameButtonAttachClear];
        }
    }];
    [selectImageController addAction:removeAttachAction];
    
    [self presentViewController:selectImageController animated:YES completion:nil];
}

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
    [self configureActionSheet];
}

@end