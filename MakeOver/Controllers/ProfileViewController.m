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
#import "LandingBriefViewController.h"

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
    
    if (!isRequestInProgress) {
        
        isRequestInProgress = YES;
        [self serviceRequest];
    }
    
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
        
        case 0:
            return profile.myRatedSaloons.count;
            break;

        default:
            return 0;
            break;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (menuListView.selectedButtonIndex == 0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
        
        UILabel *lbl_saloonName = (UILabel*)[cell viewWithTag:21];
        UILabel *lbl_saloonAddress = (UILabel*)[cell viewWithTag:22];
        UILabel *lbl_review = (UILabel*)[cell viewWithTag:23];

        NSString *saloonName = [[[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"saloonresponse"] objectForKey:@"saloonName"];
        NSString *address = [[[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"saloonresponse"] objectForKey:@"saloonAddress"];
        
        NSString *reviewDate = [[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"reviewDate"];
        NSString *review = [[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"myReview"];
        
        lbl_saloonName.text = [NSString stringWithFormat:@"%@ (%@)",saloonName,reviewDate];
        lbl_review.text = review;
        if (address != [NSNull null] && address) {
            lbl_saloonAddress.text = address;
        }
        
        return cell;
    }
    else if (menuListView.selectedButtonIndex == 1) {
        //TODO:: Favourite Saloon Parse show
        ServiceList* saloon = _favSaloons[indexPath.row];
        ServiceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
        
        cell.name.text = saloon.saloonName;
        [cell.address setText:saloon.saloonAddress];
        
        __weak ProfileViewController *selfWeak = self;

        [cell reviewWithCompletion:^(UIButton *sender, ServiceCollectionType serviceType){
            switch (serviceType) {
                    
                case tCall:
                    [selfWeak showCallingPopup:saloon.contacts];
                    break;
                    
                    
                default:
                    break;
                    
            }
        }];
        
        return cell;
    }
    else{
        FabStylist *stylist = profile.fabStylist[indexPath.row];
        ServiceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StylistCell"];
        
        [cell.name setText: [NSString stringWithFormat:@"%@ (%@)",stylist.stylistName,[stylist.sallonResponse.saloonServices componentsJoinedByString:@","]]];
        cell.descriptionService.text = stylist.sallonResponse.saloonName;
        [cell.address setText:stylist.sallonResponse.saloonMainArea];
        
        __weak ProfileViewController *selfWeak = self;
        
        [cell reviewWithCompletion:^(UIButton *sender, ServiceCollectionType serviceType){
            switch (serviceType) {
                    
                case tCall:
                    [selfWeak showCallingPopup:stylist.sallonResponse.contacts];
                    break;
                    
                    
                default:
                    break;
                    
            }
        }];
        
        return cell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServiceList *saloon = nil;
    
    if ((menuListView.selectedButtonIndex == 1)
        ||(menuListView.selectedButtonIndex == 2)) {
       
        if (menuListView.selectedButtonIndex == 1) {
            
            //GO TO saloon detail page
            saloon = _favSaloons[indexPath.row];
        }
        else if (menuListView.selectedButtonIndex == 2) {
            FabStylist *stylist = profile.fabStylist[indexPath.row];
            saloon = stylist.sallonResponse;
        }
        
        LandingBriefViewController *landingBriefViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingBriefViewController"];
        [self.navigationController pushViewController:landingBriefViewController animated:YES];
        
        dispatch_after(0.3, dispatch_get_main_queue(), ^{
            //landingBriefViewController.service = _services[indexPath.row];
            landingBriefViewController.service = saloon;
            
            [landingBriefViewController.servicesTable reloadData];
            [UtilityClass removeHudFromView:nil afterDelay:0];
            
            landingBriefViewController.saloonName.text = landingBriefViewController.service.saloonName;
            [landingBriefViewController.distance setTitle:[NSString stringWithFormat:@"%@ KM",landingBriefViewController.service.saloonDstfrmCurrLocation] forState:UIControlStateNormal];
            if (landingBriefViewController.service.saloonServices.count) {
                [landingBriefViewController.saloonDescription setText:[landingBriefViewController.service.saloonServices componentsJoinedByString:@","]];
            }
            
            if ([landingBriefViewController.service.gender isEqualToString:@"M"]) {
                landingBriefViewController.genderImage.image = [UIImage imageNamed:@"ic_male"];
            }
            
            
            [landingBriefViewController.address setText:landingBriefViewController.service.saloonAddress];
            
            landingBriefViewController.Time.text = [NSString stringWithFormat:@"%@ to %@",landingBriefViewController.service.startTime,landingBriefViewController.service.endTime];
            
            if ([landingBriefViewController.service.creditDebitCardSupport isEqualToString:@"Y"]) {
                landingBriefViewController.lbl_creditDebitStatus.text = @"Credit/Debit Card Facility : YES";
            }else{
                landingBriefViewController.lbl_creditDebitStatus.text = @"Credit/Debit Card Facility : NO";
            }
            
            
            
            [landingBriefViewController.btnReviews setTitle:[NSString stringWithFormat:@"%@ reviews",landingBriefViewController.service.sallonReviewCount] forState:UIControlStateNormal];
            
            [landingBriefViewController.startRatingView setRating:[landingBriefViewController.service.saloonRating doubleValue]];
            
            
            // Get fav saloons from saved records.
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
            NSString *documentsDirectory = [paths objectAtIndex:0]; //2
            NSString *favsPath = [documentsDirectory stringByAppendingPathComponent:@"favSaloons.plist"]; //3
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:favsPath])
            {
                
                landingBriefViewController.favourite.selected = NO;
            }
            else {
                
                // Read records
                NSArray *arrayFavSaloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:favsPath];
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[saloon saloonId] integerValue]];
                
                NSArray *arrayResult = [arrayFavSaloons filteredArrayUsingPredicate:resultPredicate];
                
                if ((arrayResult != nil) && (arrayResult.count)) {
                    landingBriefViewController.favourite.selected = YES;
                }
                else
                    landingBriefViewController.favourite.selected = NO;
            }
            
            
            // add saloon in recently viewed records.
            
            NSString *savedRecordsPath = [documentsDirectory stringByAppendingPathComponent:@"recentlyViewed.plist"]; //3
            
            if (![fileManager fileExistsAtPath:savedRecordsPath]) //if file doesn't exist at path then create
            {
                NSString *bundle = [[NSBundle mainBundle] pathForResource:@"recentlyViewed" ofType:@"plist"]; //5
                
                NSError *error;
                [fileManager copyItemAtPath:bundle toPath:savedRecordsPath error:&error]; //6
                
                if (!error) {
                    
                    NSLog(@"recentlyViewed.plist created at Documents directory.");
                    
                    //NSMutableArray *saloons = [[NSMutableArray alloc] initWithObjects:_services[indexPath.row], nil];
                    NSMutableArray *saloons = [[NSMutableArray alloc] initWithObjects:saloon, nil];
                    if (![NSKeyedArchiver archiveRootObject:saloons toFile:savedRecordsPath]) {
                        // Handle error
                        NSLog(@"error in archieving");
                    }
                    else {
                        NSLog(@"Recently viewed object saved");
                    }
                }
            }
            else {
                
                // Read & Update records
                NSMutableArray *saloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:savedRecordsPath];
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[saloon saloonId] integerValue]];
                
                NSArray *arrayResult = [saloons filteredArrayUsingPredicate:resultPredicate];
                
                if ((arrayResult != nil) && (arrayResult.count)) {
                    // Do nothing
                }
                else
                {
                    
                    if (saloons.count <10) {
                        
                        // write Record:
                        //[saloons addObject:_services[indexPath.row]];
                        [saloons addObject:saloon];
                    }
                    else {
                        //[saloons replaceObjectAtIndex:saloons.count-1 withObject:_services[indexPath.row]];
                        [saloons replaceObjectAtIndex:saloons.count-1 withObject:saloon];
                    }
                    
                    if (![NSKeyedArchiver archiveRootObject:saloons toFile:savedRecordsPath]) {
                        // Handle error
                        NSLog(@"error in archieving");
                    }
                    else
                        NSLog(@"Recently viewed object saved");
                }
                
            }
            
        });
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height;
    
    if (menuListView.selectedButtonIndex == 0) {

        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
        
        UILabel *lbl_saloonName = (UILabel*)[cell viewWithTag:21];
        UILabel *lbl_saloonAddress = (UILabel*)[cell viewWithTag:22];
        UILabel *lbl_review = (UILabel*)[cell viewWithTag:23];
        
        NSString *saloonName = [[[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"saloonresponse"] objectForKey:@"saloonName"];
        NSString *address = [[[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"saloonresponse"] objectForKey:@"mainArea"];
        
        NSString *reviewDate = [[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"reviewDate"];
        NSString *review = [[profile.myRatedSaloons objectAtIndex:indexPath.row] objectForKey:@"myReview"];
        
        lbl_saloonName.text = [NSString stringWithFormat:@"%@ (%@)",saloonName,reviewDate];
        lbl_review.text = review;
        if (address != [NSNull null] && address) {
            lbl_saloonAddress.text = address;
        }
        
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        //height = 100.0f;
    }
    else if (menuListView.selectedButtonIndex == 1) {
        //TODO:: Favourite Saloon Parse show
        
        height = 90.0f;
    }
    else{
        
        height = 80.0f;
    }
    
    return height;
}



- (IBAction)back:(UIButton *)sender {
    [(MOTabBar*)self.tabBarController addCenterButtonWithImage:[UIImage imageNamed:@"ic_profilepage_pic"] highlightImage:[UIImage imageNamed:@"ic_profilepage_pic"]];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController setSelectedIndex:0];
}

-(void)serviceRequest{
    
    NSDictionary *parameter = @{@"userId" : [NSNumber numberWithInt:[[UtilityClass RetrieveDataFromUserDefault:@"userid"] intValue]]};
    
    [[[ServiceInvoker alloc]init]serviceInvokeWithParameters:parameter requestAPI:API_GET_Profile spinningMessage:@"Loading profile" completion:
                                            ^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
                                                {
                                                    isRequestInProgress = NO;
                                                    
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
    [_tableView reloadData];
}



-(void)showCallingPopup:(NSArray*)contacts {
    
    NSLog(@"Calling PopUp");
    
    if (contacts.count) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select number to call" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        for (NSString *number in contacts) {
            [actionSheet addButtonWithTitle:number];
        }
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    else {
        [UtilityClass showAlertwithTitle:@"" message:@"Contact number not available for this saloon."];
    }
    
    
    
    
    //    [contactsObj setModalPresentationStyle:UIModalPresentationFormSheet];
    //    [contactsObj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //    CGRect rect = self.view.frame;
    //    rect.size.width = rect.size.width -20;
    //    rect.size.height = rect.size.height -20;
    //    [popoverController setPopoverContentSize:rect.size];
    //    popoverController = [[WYPopoverController alloc] initWithContentViewController:contactsObj];
    //    [popoverController presentPopoverAsDialogAnimated:YES completion:^{
    //
    //    }];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex == 0) {
        NSString *phoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}



@end
