//
//  ServiceSelectionView.h
//  TRA Smart Services
//
//  Created by RomaVizenko on 17.09.15.
//  Copyright (c) 2015 Thinkmobiles. All rights reserved.
//

#import "BaseXibView.h"

@protocol SelectedServiseViewDelegate <NSObject>

@required
- (void)buttonReportSMSDidTapped;
- (void)buttonReportWEBDidTapped;
- (void)buttonViewMyListDidTapped;

@end

@interface ServiceSelectionView : BaseXibView

@property (weak, nonatomic) id <SelectedServiseViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *reportSMSLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportWEBLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewMyListLabel;

@property (strong, nonatomic) UIImage *serviceNameReportSMSImage;
@property (strong, nonatomic) UIImage *serviceNameReportWEBImage;
@property (strong, nonatomic) UIImage *serviceNameViewMyListImage;

- (void)setRTLArabicUIStyle;
- (void)setLTREuropeUIStyle;
- (void)updateUIColor;

@end
