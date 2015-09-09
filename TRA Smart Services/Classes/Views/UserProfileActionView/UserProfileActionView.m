//
//  UserProfileActionView.m
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 09.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "UserProfileActionView.h"

@interface UserProfileActionView()

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveChangesLabel;

@end

@implementation UserProfileActionView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder nibName:@"UserProfileActionView"];
    return self;
}

#pragma mark - Public

- (void)localizeUI
{
    self.cancelLabel.text = dynamicLocalizedString(@"userProfileActionView.cancel");
    self.cancelLabel.text = dynamicLocalizedString(@"userProfileActionView.reset");
    self.cancelLabel.text = dynamicLocalizedString(@"userProfileActionView.save");
}

#pragma mark - Action

- (IBAction)cancelButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonCancelDidTapped)]){
        [self.delegate buttonCancelDidTapped];
    }
}

- (IBAction)resetButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonResetDidTapped)]){
        [self.delegate buttonResetDidTapped];
    }
}

- (IBAction)saveButtonTapped:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonSaveDidTapped)]){
        [self.delegate buttonSaveDidTapped];
    }
}

@end
