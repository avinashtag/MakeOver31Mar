//
//  LandingViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "MOSuperViewController.h"
#import "AppDelegate.h"
#import "DropDownList.h"

@interface LandingViewController : MOSuperViewController< UISearchBarDelegate,DropDownListPassValueDelegate> {

    __weak IBOutlet UIBarButtonItem *button_citySelection;
    
    DropDownList    *_ddList;
    BOOL isSearchReqQueued;
    __weak IBOutlet UISearchBar *searchBar;
    NSMutableArray *array_SearchResults;

}

@property (strong, nonatomic) IBOutlet UITableView *servicesTable;
@property (strong, nonatomic) IBOutlet UIButton *cityName;

- (void)setDDListHidden:(BOOL)hidden;

@end
