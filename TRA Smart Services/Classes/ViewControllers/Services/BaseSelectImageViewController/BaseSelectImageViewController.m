//
//  BaseSelectImageViewController.m
//  TRA Smart Services
//
//  Created by RomanVizenko on 14.08.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseSelectImageViewController.h"

@interface BaseSelectImageViewController ()

@end

@implementation BaseSelectImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
}

@end