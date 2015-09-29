//
//  UserProfileActionView.m
//  TRA Smart Services
//
//  Created by Admin on 09.09.15.
//

#import "UserProfileActionView.h"

@interface UserProfileActionView()

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveChangesLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation UserProfileActionView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder nibName:NSStringFromClass([self class])];
    return self;
}

#pragma mark - Public

- (void)localizeUI
{
    self.cancelLabel.text = dynamicLocalizedString(@"userProfileActionView.cancel");
    self.resetLabel.text = dynamicLocalizedString(@"userProfileActionView.reset");
    self.saveChangesLabel.text = dynamicLocalizedString(@"userProfileActionView.save");
}

- (void)setRTLStyle
{
    [self transformViewElements:TRANFORM_3D_SCALE];
}

- (void)setLTRStyle
{
    [self transformViewElements:CATransform3DIdentity];
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

#pragma mark - Private

- (void)transformViewElements:(CATransform3D)transfrom
{
    self.layer.transform = transfrom;
    self.saveChangesLabel.layer.transform = transfrom;
    self.resetLabel.layer.transform = transfrom;
    self.cancelLabel.layer.transform = transfrom;
    self.saveButton.layer.transform = transfrom;
}

@end
