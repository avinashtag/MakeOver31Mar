//
//  LandingBriefViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceList.h"
#import "ReviewViewController.h"
#import "WYPopoverController.h"
#import "ASStarRatingView.h"

@interface LandingBriefViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>{
    WYPopoverController *popoverController;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_creditDebitStatus;

@property (nonatomic, strong) NSArray *array_service;
@property (weak, nonatomic) IBOutlet UIView *view_tableContainer;


@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_leading;
@property (weak, nonatomic) IBOutlet UIButton *btn_info;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet ASStarRatingView *startRatingView;
@property (weak, nonatomic) IBOutlet UIButton *btnReviews;

@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UIButton *favourite;
@property (weak, nonatomic) IBOutlet UILabel *saloonDescription;
@property (weak, nonatomic) IBOutlet UIButton *distance;
@property (weak, nonatomic) IBOutlet UILabel *saloonName;
@property (weak, nonatomic) IBOutlet UIButton *cityName;
@property (weak, nonatomic) IBOutlet UICollectionView *servicesTable;
@property (strong, nonatomic) ServiceList *service;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UIView *headerMenu;
@property (weak, nonatomic) IBOutlet UIView *headerGallery;
@property (weak, nonatomic) IBOutlet UIView *headerStylist;
@property (weak, nonatomic) IBOutlet UITableView *tbl_stylist;


- (IBAction)segmentSelection:(UISegmentedControl *)sender;
- (IBAction)favButtonDidTap:(id)sender;

- (IBAction)callButtonDidTap:(id)sender;
- (IBAction)showInfo:(id)sender;

@end
