//
//  ProfileViewController.h
//  MakeOver
//
//  Created by Ekta on 08/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HTHorizontalSelectionList.h"

@interface ProfileCollection : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

typedef enum {
    Reviews= 0,
    FavSaloons,
    FavStylists
    
} selectedMenu;


@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UIActionSheetDelegate> {
    
    HTHorizontalSelectionList *menuListView;
    NSArray *menuItems;
    
    BOOL isRequestInProgress;
}

@property (weak, nonatomic) IBOutlet UIView *HTHorizontalView;

//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *favSaloons;
@property (strong, nonatomic) NSMutableArray *favStylists;


- (IBAction)userDidLogout:(id)sender;

@end
