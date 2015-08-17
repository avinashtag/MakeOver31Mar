//
//  LandingServicesViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"
#import "City.h"
#import "ServiceInvoker.h"
#import "WYPopoverController.h"
#import "DropDownList.h"
#import "DropDownListPassValueDelegate.h"


typedef enum {
    sHAIR= 1,
    sFACEBODY,
    sSPA,
    sMAKEUPBRIDAL,
    sMEDISPA,
    sTATOOPIERCING,
    sNAILS,
    sTUTORIAL,
    sOFFERS,
}
MenuServiceType;

@interface LandingServicesViewController : UIViewController<HTHorizontalSelectionListDataSource,HTHorizontalSelectionListDelegate,ServiceInvokerDelegate,WYPopoverControllerDelegate,UISearchBarDelegate, UIActionSheetDelegate,DropDownListPassValueDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *array_Saloons;
    
    NSMutableArray *array_favSaloons;
    BOOL isSearchReqQueued;
    NSMutableArray *array_SearchResults;
    
    DropDownList    *_ddList;

    BOOL isFilterON;
    NSMutableArray *array_searchResultsONFilteredItems;

    __weak IBOutlet NSLayoutConstraint *constraintTopMargin_tableView;
    __weak IBOutlet UIButton *backButton;
    
    BOOL isPageLimitReached;
    
    UIView *loadMoreView;
}

@property (weak, nonatomic) IBOutlet UITableView *servicesTable;
@property (assign,nonatomic) NSInteger serviceId;
@property (assign,nonatomic) NSInteger nextPageNumber;
@property (nonatomic,assign) __block BOOL isFilterSortApplied;
@property (nonatomic,assign) __block BOOL isFiltersApplied;



@property (strong, nonatomic) HTHorizontalSelectionList *menuListView;
@property (strong, nonatomic) __block NSMutableArray *services;
@property (weak, nonatomic) IBOutlet UIView *HTHorizontalView;
@property (weak, nonatomic) IBOutlet UIButton *cityName;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,assign) BOOL isComingFromSearch;
@property (nonatomic,assign) NSUInteger selectedSegmentFromSearch;

- (void)setDDListHidden:(BOOL)hidden;

@end
