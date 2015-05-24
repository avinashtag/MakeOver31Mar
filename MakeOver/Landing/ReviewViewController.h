//
//  ReviewViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 15/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceList.h"

@interface ReviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *reviewsTable;
@property (strong, nonatomic)__block NSMutableArray* reviews;
@property (strong, nonatomic) ServiceList *service;

@end
