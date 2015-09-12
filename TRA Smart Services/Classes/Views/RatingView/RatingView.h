//
//  RatingView.h
//  TRA Smart Services
//
//  Created by Anatoliy Dalekorey on 9/2/15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseXibView.h"

@protocol RatingViewDelegate <NSObject>

- (void)ratingChanged:(NSInteger)rating;

@end

@interface RatingView : BaseXibView

@property (weak, nonatomic) id <RatingViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *chooseRating;

@end
