//
//  CompliantViewController.h
//  TRA Smart Services
//
//  Created by Admin on 14.08.15.
//

#import "BaseSelectImageViewController.h"

@interface CompliantViewController : BaseSelectImageViewController <UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (assign, nonatomic) ComplianType type;

@end
