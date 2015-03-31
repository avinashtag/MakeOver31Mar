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

@interface LandingViewController : MOSuperViewController< UISearchBarDelegate> {

    __weak IBOutlet UIBarButtonItem *button_citySelection;
}

@property (strong, nonatomic) IBOutlet UITableView *servicesTable;
@property (strong, nonatomic) IBOutlet UIButton *cityName;
@end
