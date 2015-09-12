//
//  SegmentView.h
//  
//
//  Created by Kirill Gorbushko on 03.08.15.
//
//
@class SegmentView;

@protocol SegmentViewDelegate <NSObject>

@optional
- (void)segmentControlDidPressedItem:(NSUInteger)item inSegment:(SegmentView *)segment;

@end

IB_DESIGNABLE
@interface SegmentView : UIView

@property (weak, nonatomic) id <SegmentViewDelegate> delegate;

@property (assign, nonatomic) IBInspectable NSUInteger segmentViewElementsCount;
@property (assign, nonatomic) IBInspectable NSUInteger segmentSeparatorWidth;
@property (strong, nonatomic) IBInspectable UIColor *segmentSeparatorColor;
@property (strong, nonatomic) IBInspectable UIColor *segmentSelectedTintColor;
@property (strong, nonatomic) IBInspectable UIColor *segmentDeselectedTintColor;
@property (assign, nonatomic) IBInspectable NSUInteger segmentTag;
@property (strong, nonatomic) UIColor *segmentSelectedBacrgroundColor;

/** name of segmentItems or images*/
@property (strong, nonatomic) NSArray *segmentItems;

/** shoul be dictionary inside; q-ty equal to segmentItems.count*/
@property (strong, nonatomic) NSArray *segmentItemsAttributes;

- (void)setSegmentItemSelectedWithTag:(NSUInteger)tag;

@end
