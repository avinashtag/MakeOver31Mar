//
//  ProfileViewController.m
//  MakeOver
//
//  Created by Ekta on 08/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "ProfileViewController.h"
#import "MOTabBar.h"
#import "ServiceInvoker.h"
#import "DataModels.h"
#import "UIImageView+WebCache.h"
#import "ServiceList.h"
#import "ServiceCell.h"

@implementation ProfileCollection





@end

@interface ProfileViewController (){
    __block Profile *profile;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuListView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    menuItems = @[@"My Reviews",@"Fav Saloons",@"Fav Stylists"];
    menuListView.delegate = self;
    menuListView.dataSource = self;
    [menuListView setBackgroundColor:[UIColor clearColor]];
    [self.HTHorizontalView addSubview:menuListView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self serviceRequest];
    [self.navigationController setNavigationBarHidden:YES];
//    [self.tabBarController.tabBar setHidden:YES];
//    [_pageControl setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Get fav saloons from saved records.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *favsPath = [documentsDirectory stringByAppendingPathComponent:@"favSaloons.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:favsPath]) //if file doesn't exist at path then create
    {
        
        self.favSaloons = [NSMutableArray new];
    }
    else {
        
        if ((self.favSaloons !=nil) && (self.favSaloons.count)) {
            [self.favSaloons removeAllObjects];
        }
        // Read & Update records
        self.favSaloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:favsPath];
    }
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- Scroll Menu Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return menuItems.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return menuItems[index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{

    [_tableView reloadData];
}

-(NSString*)reuseIdentifier{
    
    switch (menuListView.selectedButtonIndex) {
        case Reviews:
            return  @"MyReviewsCollection";
            
            break;
            
        case FavSaloons:
            return  @"FavSaloonCollection";
            
            break;
            
        case FavStylists:
            return  @"favStylistCollection";
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (menuListView.selectedButtonIndex) {
        case 2:
            return profile.fabStylist.count;
            break;
            
        case 1:
            return self.favSaloons.count;
            break;
            
        default:
            return 2;
            break;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (menuListView.selectedButtonIndex == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
        return cell;
    }
    else if (menuListView.selectedButtonIndex == 1) {
        //TODO:: Favourite Saloon Pasrse show
        ServiceList* saloon = _favSaloons[indexPath.row];
        ServiceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
        
        cell.name.text = saloon.saloonName;
        [cell.address setText:saloon.saloonAddress];
        
        return cell;
    }
    else{
        FabStylist *stylist = profile.fabStylist[indexPath.row];
        ServiceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StylistCell"];
        [cell.userImage setImageWithURL:[NSURL URLWithString:stylist.imageUrl] placeholderImage:nil];
        [cell.name setText:stylist.stylistName];
        [cell.address setText:[stylist.stylishPosition isEqualToString:@"J"]?@"Junior":@"Senior"];
        return cell;
    }
    
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 65.0f;
}

- (IBAction)back:(UIButton *)sender {
    [(MOTabBar*)self.tabBarController addCenterButtonWithImage:[UIImage imageNamed:@"ic_profilepage_pic"] highlightImage:[UIImage imageNamed:@"ic_profilepage_pic"]];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController setSelectedIndex:0];
}

-(void)serviceRequest{
    
    NSDictionary *parameter = @{@"userId" : [NSNumber numberWithInt:[[UtilityClass RetrieveDataFromUserDefault:@"userid"] intValue]]};
    
    [[[ServiceInvoker alloc]init]serviceInvokeWithParameters:parameter requestAPI:API_GET_Profile spinningMessage:@"Loading profile" completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {
        if (result == sirSuccess) {
            NSError *error = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
            
            profile = [Profile modelObjectWithDictionary:responseDict[@"object"]];
            [self loadProfile];
            
        }
    }];
}

-(void)loadProfile{
    
    [_username setText:profile.name];
    [_userEmail setText:profile.email];
    [_mobile setText:profile.mobileNo];
    [_profilePic setImageWithURL:[NSURL URLWithString:profile.imageUrl] placeholderImage:[UIImage imageNamed:@"ic_foot_profilepic.png"]];

    
}
@end
