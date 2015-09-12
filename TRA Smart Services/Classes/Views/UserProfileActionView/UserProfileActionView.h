//
//  UserProfileActionView.h
//  TRA Smart Services
//
//  Created by Kirill Gorbushko on 09.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
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

@end
