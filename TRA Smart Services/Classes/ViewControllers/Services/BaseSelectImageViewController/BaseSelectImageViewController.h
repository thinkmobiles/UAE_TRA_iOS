//
//  BaseSelectImageViewController.h
//  TRA Smart Services
//
//  Created by Admin on 14.08.15.
//

@interface BaseSelectImageViewController : BaseServiceViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage *selectImage;

- (void)selectImagePickerController;
- (void)addAttachButtonTextField:(UITextField *)textField;

@end
