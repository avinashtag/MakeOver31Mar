//
//  FilterViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 22/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"

@class NMRangeSlider;

@interface FilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicked;


@end


@interface FilterViewController : UIViewController<HTHorizontalSelectionListDataSource,HTHorizontalSelectionListDelegate>{

    __weak IBOutlet UIView *view_distanceBtnContainer;

    __weak IBOutlet UIView *view_salonRatingBtnContainer;
    
    __weak IBOutlet UIView *view_stylistBtnContainer;
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
- (IBAction)action_sortBystylistClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) IBOutlet UIView *filterHeader;
@property (weak, nonatomic) IBOutlet UIView *sortByHeader;
@property (strong, nonatomic) HTHorizontalSelectionList *menuListView;
@property (weak, nonatomic) IBOutlet UIButton *btn_female;
@property (weak, nonatomic) IBOutlet UIButton *btn_male;
@property (weak, nonatomic) IBOutlet UITextField *txt_time;
@property (weak, nonatomic) IBOutlet UITextField *txt_ampm;
@property (weak, nonatomic) IBOutlet NMRangeSlider *doubleSlider;
@property (weak, nonatomic) UILabel *label_doubleSlider;
@property (weak, nonatomic) IBOutlet UIButton *btn_fromTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_toTime;
@property (weak, nonatomic) IBOutlet UIView *view_datePicker;

@property (copy) void(^callback)(NSDictionary *params);

- (IBAction)doubleSliderChanged:(id)sender;

- (IBAction)action_datePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
- (IBAction)action_cancelPicker:(id)sender;
- (IBAction)timePickerHelper:(id)sender;
@end
