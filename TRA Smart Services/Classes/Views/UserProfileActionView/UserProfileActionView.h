//
//  UserProfileActionView.h
//  TRA Smart Services
//
//  Created by Admin on 09.09.15.
//

#import "BaseXibView.h"

@protocol UserProfileActionViewDelegate <NSObject>

@required
- (void)buttonCancelDidTapped;
- (void)buttonResetDidTapped;
- (void)buttonSaveDidTapped;

@end

@interface UserProfileActionView : BaseXibView

@property (weak, nonatomic) id <UserProfileActionViewDelegate> delegate;

- (void)setLTRStyle;
- (void)setRTLStyle;
- (void)localizeUI;

@end
