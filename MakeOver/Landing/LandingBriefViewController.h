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

@interface LandingBriefViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    WYPopoverController *popoverController;
}

@property (nonatomic, strong) NSArray *array_service;
@property (weak, nonatomic) IBOutlet UIView *view_tableContainer;


@property (weak, nonatomic) IBOutlet UILabel *address;

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
@end
