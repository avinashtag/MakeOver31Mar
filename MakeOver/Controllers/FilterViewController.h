//
//  FilterViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 22/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"


@interface FilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicked;


@end


@interface FilterViewController : UIViewController<HTHorizontalSelectionListDataSource,HTHorizontalSelectionListDelegate>{

    __weak IBOutlet UIView *view_distanceBtnContainer;

    __weak IBOutlet UIView *view_salonRatingBtnContainer;
    
    NSMutableDictionary *dict_filterSortingParams;
}

@property (weak, nonatomic) IBOutlet UIView *animatedView;
@property (weak, nonatomic) IBOutlet UIView *filterSegment;
@property (weak, nonatomic) IBOutlet UIView *sortSegment;
@property (weak, nonatomic) IBOutlet UIView *horizontalUI;
@property (weak, nonatomic) IBOutlet UIButton *Done;
- (IBAction)doneClicked:(UIButton *)sender;
- (IBAction)DistanceClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *SaloonRating;
- (IBAction)SallonRatingClicked:(UIButton *)sender;
- (IBAction)genderFilter:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) IBOutlet UIView *filterHeader;
@property (weak, nonatomic) IBOutlet UIView *sortByHeader;
@property (strong, nonatomic) HTHorizontalSelectionList *menuListView;
@property (weak, nonatomic) IBOutlet UIButton *btn_female;
@property (weak, nonatomic) IBOutlet UIButton *btn_male;
@property (weak, nonatomic) IBOutlet UITextField *txt_time;
@property (weak, nonatomic) IBOutlet UITextField *txt_ampm;

@property (copy) void(^callback)(NSDictionary *params);

- (IBAction)action_datePicker:(id)sender;
@end
