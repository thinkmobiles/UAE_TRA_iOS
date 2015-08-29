//
//  SegmentView.m
//  
//
//  Created by Kirill Gorbushko on 03.08.15.
//
//

#import "SegmentView.h"

static CGFloat const SegmentSeparatorWidth = 1.f;

@interface SegmentView()

@property (assign, nonatomic) NSInteger selectedTag;

@end

@implementation SegmentView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareParameters];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawElements];
}

#pragma mark - CustomAccessors

-(void)setSegmentItems:(NSArray *)segmentItems
{
    _segmentItems = segmentItems;
    
    [self drawElements];
}

- (void)setSegmentSelectedTintColor:(UIColor *)segmentSelectedTintColor
{
    _segmentSelectedTintColor = segmentSelectedTintColor;
    
    [self drawElements];
}

#pragma mark - Public

- (void)setSegmentItemSelectedWithTag:(NSUInteger)tag
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            ((UIButton *)subview).selected = NO;
            if (subview.tag == tag) {
                ((UIButton *)subview).selected = YES;
                self.selectedTag = tag;
            }
        }
    }
}

#pragma mark - Private

/** used inverted states */
- (void)drawElements
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    CGSize rectSize = self.bounds.size;
    CGSize elementSize = CGSizeMake(((rectSize.width - self.segmentViewElementsCount * SegmentSeparatorWidth)/ self.segmentViewElementsCount), rectSize.height);
    
    for (int i = 0; i < self.segmentViewElementsCount; i++) {
        UIButton *segmentPart = [[UIButton alloc] initWithFrame:CGRectMake((elementSize.width + SegmentSeparatorWidth) * i, 0, elementSize.width, elementSize.height)];
        if ([[self.segmentItems firstObject] isKindOfClass:[NSString class]]) {
            if (self.segmentItemsAttributes.count) {
                NSMutableDictionary *normalAttributes = [self.segmentItemsAttributes[i] mutableCopy];
                [normalAttributes setValue:self.segmentSelectedTintColor forKey:NSForegroundColorAttributeName];
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:self.segmentItems[i] attributes:normalAttributes];
                [segmentPart setAttributedTitle:attributedTitle forState:UIControlStateNormal];

                NSMutableDictionary *selectedAttributes = [self.segmentItemsAttributes[i] mutableCopy];
                [selectedAttributes setValue:self.segmentDeselectedTintColor forKey:NSForegroundColorAttributeName];
                NSAttributedString *selectedAttributedTitle = [[NSAttributedString alloc] initWithString:self.segmentItems[i] attributes:selectedAttributes];
                [segmentPart setAttributedTitle:selectedAttributedTitle forState:UIControlStateSelected];
            } else {
                [segmentPart setTitle:self.segmentItems[i] forState:UIControlStateNormal];
            }
        } else  if ([[self.segmentItems firstObject] isKindOfClass:[UIImage class]]) {
            [segmentPart setImage:self.segmentItems[i] forState:UIControlStateNormal];
        }
        [segmentPart addTarget:self action:@selector(segmentControllDidPressed:) forControlEvents:UIControlEventTouchDown];
        [segmentPart setTitleColor:self.segmentSelectedTintColor forState:UIControlStateNormal];
        [segmentPart setTitleColor:self.segmentDeselectedTintColor forState:UIControlStateSelected];
        
        segmentPart.tag = i;
        
        if (segmentPart.tag == self.selectedTag) {
            segmentPart.selected = YES;
        }
    
        [self addSubview:segmentPart];
        
        if (i != self.segmentViewElementsCount - 1) {
            UIView *segmentSeparatorView = [[UIView alloc] initWithFrame:CGRectMake((elementSize.width * (i + 1) + SegmentSeparatorWidth * i), (elementSize.height * 0.5f) / 2, SegmentSeparatorWidth, elementSize.height * 0.5f)];
            segmentSeparatorView.backgroundColor = self.segmentSeparatorColor;
            
            [self addSubview:segmentSeparatorView];
        }
    }
}

- (void)prepareParameters
{
    if (!self.segmentSeparatorColor) {
        self.segmentSeparatorColor = [UIColor lightGrayColor];
    }
    if (!self.segmentViewElementsCount) {
        self.segmentViewElementsCount = 2;
    }
    if (!self.segmentItems) {
        self.segmentItems = @[@"1", @"2"];
    }
    if (!self.segmentSelectedTintColor) {
        self.segmentSelectedTintColor = [UIColor blackColor];
    }
    if (!self.segmentDeselectedTintColor) {
        self.segmentDeselectedTintColor = [UIColor lightGrayColor];
    }
    self.layer.cornerRadius = 5.f;
    self.selectedTag = -1;
}

#pragma mark - Actions

- (void)segmentControllDidPressed:(UIButton *)segment
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControlDidPressedItem:inSegment:)]) {
        [self.delegate segmentControlDidPressedItem:segment.tag inSegment:self];
    }
}

@end