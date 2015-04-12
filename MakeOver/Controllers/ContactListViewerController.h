//
//  ContactListViewerController.h
//  MakeOver
//
//  Created by Himanshu Yadav on 12/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListViewerController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView_contacts;
@property (strong,nonatomic)NSArray *array_contacts;
@end
