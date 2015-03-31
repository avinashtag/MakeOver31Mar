//
//  RecentSaloonViewController.h
//  MakeOver
//
//  Created by Pankaj Yadav on 29/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentSaloonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *serviceTable;
@property (strong, nonatomic) __block NSMutableArray *services;
@property (weak, nonatomic) IBOutlet UIButton *cityName;

@end
