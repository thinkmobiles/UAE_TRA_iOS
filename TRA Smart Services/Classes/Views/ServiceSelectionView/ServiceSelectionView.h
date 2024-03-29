//
//  ServiceSelectionView.h
//  TRA Smart Services
//
//  Created by Admin on 17.09.15.
//

#import "BaseXibView.h"

@protocol ServiceSelectionViewDelegate <NSObject>

@required
- (void)buttonReportSMSDidTapped;
- (void)buttonReportWEBDidTapped;
- (void)buttonViewMyListDidTapped;

@end

@interface ServiceSelectionView : BaseXibView

@property (weak, nonatomic) id <ServiceSelectionViewDelegate> delegate;

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
