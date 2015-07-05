//
//  SearchResultsController.h
//  MakeOver
//
//  Created by Pankaj Yadav on 31/05/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HTHorizontalSelectionList.h"
#import "City.h"
#import "ServiceInvoker.h"
#import "WYPopoverController.h"
#import "DropDownList.h"
#import "DropDownListPassValueDelegate.h"


@interface SearchResultsController : UIViewController <HTHorizontalSelectionListDataSource,HTHorizontalSelectionListDelegate,ServiceInvokerDelegate,WYPopoverControllerDelegate,UISearchBarDelegate, UIActionSheetDelegate,DropDownListPassValueDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *array_Saloons;
    
    NSMutableArray *array_favSaloons;
    BOOL isSearchReqQueued;
    NSMutableArray *array_SearchResults;
    
    DropDownList    *_ddList;
    
    __weak IBOutlet NSLayoutConstraint *constraintTopMargin_tableView;
    __weak IBOutlet UIButton *backButton;
}

@property (weak, nonatomic) IBOutlet UITableView *servicesTable;
@property (assign,nonatomic) NSInteger serviceId;
@property (assign,nonatomic) NSInteger nextPageNumber;

@property (nonatomic, strong) NSString *defaultServiceName;
@property (assign,nonatomic) NSInteger defaultServiceId;

@property (nonatomic, strong) NSMutableArray *searcheSaloonServices;
@property (strong, nonatomic) HTHorizontalSelectionList *menuListView;
@property (strong, nonatomic) __block NSMutableArray *services;
@property (weak, nonatomic) IBOutlet UIView *HTHorizontalView;
@property (nonatomic,strong) NSMutableDictionary *requestParams;
@property (nonatomic,assign) NSUInteger selectedSegmentFromSearch;

@property (weak, nonatomic) IBOutlet UIButton *cityName;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;



- (void)setDDListHidden:(BOOL)hidden;



@end
