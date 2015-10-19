//
//
//  Created by Admin on 10.11.14.
//

static NSString *const KeyIsTutorialShowed = @"KeyIsTutorialShowed";

@interface TutorialViewController : BaseDynamicUIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) void (^didCloseViewController)();

@end
