//
//  HomeSearchViewController.h
//  TRA Smart Services
//
//  Created by Admin on 09.09.15.
//

@interface HomeSearchViewController : BaseDynamicUIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImage *fakeBackground;
@property (strong, nonatomic) void (^didSelectService)(NSInteger selectedServiseID);

@end
