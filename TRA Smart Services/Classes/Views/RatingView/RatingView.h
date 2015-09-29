//
//  RatingView.h
//  TRA Smart Services
//
//  Created by Admin on 9/2/15.
//

#import "BaseXibView.h"

@protocol RatingViewDelegate <NSObject>

- (void)ratingChanged:(NSInteger)rating;

@end

@interface RatingView : BaseXibView

@property (weak, nonatomic) id <RatingViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *chooseRating;

@end
