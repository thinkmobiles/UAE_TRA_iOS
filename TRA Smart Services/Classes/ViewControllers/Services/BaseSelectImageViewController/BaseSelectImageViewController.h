//
//  BaseSelectImageViewController.h
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

@interface BaseSelectImageViewController : BaseServiceViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage *selectImage;

- (void)selectImagePickerController;
- (void)addAttachButtonTextField:(UITextField *)textField;

@end
