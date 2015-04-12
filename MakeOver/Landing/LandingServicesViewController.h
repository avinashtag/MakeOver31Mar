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

@interface LandingServicesViewController : UIViewController<HTHorizontalSelectionListDataSource,HTHorizontalSelectionListDelegate,ServiceInvokerDelegate,WYPopoverControllerDelegate,UISearchBarDelegate> {
    
    NSArray *array_Saloons;
}

@property (weak, nonatomic) IBOutlet UITableView *servicesTable;
@property (assign,nonatomic) NSInteger serviceId;
@property (strong, nonatomic) HTHorizontalSelectionList *menuListView;
@property (strong, nonatomic) __block NSMutableArray *services;
@property (weak, nonatomic) IBOutlet UIView *HTHorizontalView;
@property (weak, nonatomic) IBOutlet UIButton *cityName;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
