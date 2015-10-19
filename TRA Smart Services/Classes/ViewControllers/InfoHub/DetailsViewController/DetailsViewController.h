//
//  DetailsViewController.h
//  TRA Smart Services
//
//  Created by Admin on 18.08.15.
//

@interface DetailsViewController : BaseDynamicUIViewController

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (copy, nonatomic) NSString *titleText;
@property (copy, nonatomic) NSString *sourceText;
@property (copy, nonatomic) NSString *aboutText;
@property (strong, nonatomic) NSDate *titlaDate;
@property (strong, nonatomic) UIImage *logoImage;
@property (copy, nonatomic) NSAttributedString *contentText;

@end