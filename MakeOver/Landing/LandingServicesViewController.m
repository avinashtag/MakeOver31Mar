//
//  LandingServicesViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "LandingServicesViewController.h"
#import "ServiceCell.h"
#import "LandingBriefViewController.h"
#import "ServiceInvoker.h"
#import "ServiceList.h"

#import "WYPopoverController.h"
#import "CustomSelection.h"
#import "City.h"
#import "AppDelegate.h"
#import "OfferDetailViewController.h"

#import "ReviewViewController.h"
#import "RatingViewController.h"
#import "ImageViewerViewController.h"

#import "FilterViewController.h"
#import "StyleList.h"

@interface LandingServicesViewController (){
    WYPopoverController *popoverController;
    FilterViewController *filterViewController;
    
    NSArray *arrayFilteredResults;
    BOOL isSortingByStylist;
}

@end

@implementation LandingServicesViewController

typedef enum {
    sHAIR= 0,
    sFACEBODY,
    sSPA,
    sMAKEUPBRIDAL,
    sMEDISPA,
    sTATOOPIERCING,
    sNAILS,
    sTUTORIAL,
    sOFFERS,
}MenuServiceType;

static NSArray *menuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuListView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    menuItems = @[@"HAIR",@"FACE & BODY",@"SPA",@"MAKEUP & BRIDAL",@"MEDISPA",@"TATOO & PIERCING",@"NAILS",@"TUTORIALS",@"OFFERS"];

    self.menuListView.delegate = self;
    self.menuListView.dataSource = self;[self.menuListView setBackgroundColor:[UIColor clearColor]];
    [self.HTHorizontalView addSubview:self.menuListView];
    
    [self.menuListView reloadData];
    
    [self.menuListView buttonWasTapped:[self.menuListView.buttons objectAtIndex:_serviceId]];
    self.menuListView.selectedButtonIndex = _serviceId;

    
    if (_isComingFromSearch) {
        // hide search bar
        // hide scroller
        // set segment based on selected segment at search
        // then load results
        
        self.searchBar.hidden = YES;
        self.HTHorizontalView.hidden = YES;
        
        constraintTopMargin_tableView.active = NO;
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_servicesTable attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:53];
        
        [self.view addConstraint:topConstraint];
        
        [self.servicesTable updateConstraints];

        _menuListView.selectedButtonIndex = self.selectedSegmentFromSearch;
        
        arrayFilteredResults = [NSArray arrayWithArray:_services];
        [self.servicesTable reloadData];
    }
    else{
    
        if (_serviceId == 0)// if first tab selected
            [self serviceLoad];
        
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [ServiceInvoker sharedInstance].city!=nil? [_cityName setTitle:[ServiceInvoker sharedInstance].city.cityName forState:UIControlStateNormal]:NSLog(@"");
        
        arrayFilteredResults = [NSArray new];
        array_SearchResults = [NSMutableArray new];
        
        _ddList = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
        _ddList._delegate = self;
        
        [_ddList.view setFrame:CGRectMake(0,self.searchBar.frame.origin.y + self.searchBar.frame.size.height, self.view.frame.size.width, 0)];
        [self.view addSubview:_ddList.view];

        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.tabBarController.selectedIndex == 1) {
        backButton.hidden = YES;
    }
    // Get fav saloons from saved records.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *favsPath = [documentsDirectory stringByAppendingPathComponent:@"favSaloons.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:favsPath]) //if file doesn't exist at path then create
    {
        // Do nothing
        array_favSaloons = [NSMutableArray new];
    }
    else {
        
        // Read records
        array_favSaloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:favsPath];
    }
    
    [_servicesTable reloadData];
    
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)filter:(id)sender{
    filterViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FilterViewController class])];
    [filterViewController.view setBackgroundColor:[UIColor clearColor]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:filterViewController.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:filterViewController.view];
    
    __weak NSArray *weakArray = _services;
    
    __weak LandingServicesViewController *weakSelf = self;
    
    filterViewController.callback = ^(NSDictionary *params) {
        NSLog(@"%@",params);
        
        NSString *sortingByFavouriteStylist   = [params objectForKey:@"sortByFavouriteStylist"];
        NSString *sortingByRating   = [params objectForKey:@"sortByRating"];
        NSString *sortingByDistance = [params objectForKey:@"sortByDistance"];
        NSString *filterBySex       = [params objectForKey:@"filterBySex"];
        NSString *filterByParticularTime = [params objectForKey:@"filterByTime"];
        NSString *filterByTimeRange = [params objectForKey:@"filterByRange"];
        NSString *filterByCreditCardHolders = [params objectForKey:@"filterByCardPresent"];

        NSString *str_isSorting = [params objectForKey:@"isSorting"];
        NSString *str_isFiltering = [params objectForKey:@"isFiltering"];

        if ([str_isSorting isEqualToString:@"YES"]) {
            
            isSortingByStylist = NO;
            
            if (sortingByRating != nil && sortingByRating.length != 0 && [sortingByRating isEqualToString:@"YES"]) {
                
                
                NSArray *sortedArray;
                sortedArray = [arrayFilteredResults sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSNumber *first = [(ServiceList*)a saloonRating];
                    NSNumber *second = [(ServiceList*)b saloonRating];
                    return [second compare:first];
                }];
                
                arrayFilteredResults = sortedArray;
                
                [weakSelf.servicesTable reloadData];
            }
            
            
            if (sortingByDistance != nil && sortingByDistance.length != 0 && [sortingByDistance isEqualToString:@"YES"]) {
                
                NSArray *sortedArray;
                sortedArray = [arrayFilteredResults sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSNumber *first = [NSNumber numberWithFloat:[[(ServiceList*)a saloonDstfrmCurrLocation] floatValue]] ;
                    NSNumber *second = [NSNumber numberWithFloat:[[(ServiceList*)b saloonDstfrmCurrLocation] floatValue]];
                    return [first compare:second];
                }];
                
                arrayFilteredResults = sortedArray;
                
                [weakSelf.servicesTable reloadData];
            }
            
            
            if (sortingByFavouriteStylist != nil && sortingByFavouriteStylist.length != 0 && [sortingByFavouriteStylist isEqualToString:@"YES"]) {
                
//                FavouriteStylistController *favouriteStylistController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDFavouriteStylist"];
//                [self.navigationController pushViewController:favouriteStylistController animated:YES];
                isSortingByStylist = YES;
                [weakSelf webServiceSortByStylist];
                }
        }
        
        if ([str_isFiltering isEqualToString:@"YES"]){
        
            if (filterBySex != nil && filterBySex.length != 0) {
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.gender LIKE[c] %@",filterBySex];
                
                arrayFilteredResults = [weakArray filteredArrayUsingPredicate:resultPredicate];
                
                [weakSelf.servicesTable reloadData];
            }
            
            
            if (filterByParticularTime != nil && filterByParticularTime.length != 0) {
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.startTime LIKE[c] %@",filterBySex];
                
                arrayFilteredResults = [weakArray filteredArrayUsingPredicate:resultPredicate];
                
                [weakSelf.servicesTable reloadData];
            }
            
            if (filterByTimeRange != nil && filterByTimeRange.length != 0) {
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.startTiming <= %@ <= SELF.endTiming",filterBySex];
                
                arrayFilteredResults = [weakArray filteredArrayUsingPredicate:resultPredicate];
                
                [weakSelf.servicesTable reloadData];
            }
            
            
            if (filterByCreditCardHolders != nil && filterByCreditCardHolders.length != 0 && [filterByCreditCardHolders isEqualToString:@"YES"]) {
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.creditDebitCardSupport LIKE[c] %@",@"Y"];
                
                arrayFilteredResults = [weakArray filteredArrayUsingPredicate:resultPredicate];
                
                [weakSelf.servicesTable reloadData];
            }
        }
        
        
    };
}

-(void)serviceLoad{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"serviceId"] = @(_serviceId);
    CLLocationCoordinate2D location = [ServiceInvoker sharedInstance].coordinate;
    
    if (self.tabBarController.selectedIndex == 1) {
        parameters[@"curr_lat"] =[NSString stringWithFormat:@"%f",location.latitude];//:@"28.089";
        parameters[@"curr_Long"] =[NSString stringWithFormat:@"%f",location.longitude];// @"77.986";
    }
    else
    {
        parameters[@"curr_lat"] = @"";
        parameters[@"curr_Long"] = @"";
    }
    
        NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    parameters[@"cityId"] = idCity!=nil ? idCity : @"1";
    
    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_SALOONS spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {
        if (result == sirSuccess) {
            NSError *error = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
            
            if ([responseDict objectForKey:@"object"] != [NSNull null]) {
                
                array_Saloons = [responseDict objectForKey:@"object"];
            }
            _services = [[ServiceList initializeWithResponse:responseDict] mutableCopy];
            
            arrayFilteredResults = [NSArray arrayWithArray:_services];
            
            [self.servicesTable reloadData];
        }
    }];
}


-(void)webServiceSortByStylist{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"cityId",@"1",@"serviceId",@"3",@"userId", nil];
    
    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_FAV_STYLIST spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
     {
         
         if (result == sirSuccess) {
             
             NSError *error = nil;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
             
             if ([responseDict objectForKey:@"object"] != [NSNull null]) {
                 
                 array_Saloons = [responseDict objectForKey:@"object"];

             }
             _services = [[ServiceList initializeWithFavStylistsResponse:responseDict] mutableCopy];
             
             arrayFilteredResults = [NSArray arrayWithArray:_services];
             
             [self.servicesTable reloadData];
             
         }else if (sirFailed){
             
         }
     }];
}


-(void)webServiceWithType:(MenuServiceType)serviceType{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    parameters[@"cityId"] = idCity!=nil ? idCity : @"1";
    
    NSString *userId = @"1";
    
    [parameters setObject:userId forKey:@"userId"];
    
    switch (serviceType) {
        case sTUTORIAL:
        {
            [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_TUTORIAL spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
             {
                 
                 if (result == sirSuccess) {
                     
                     NSError *error = nil;
                     NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
                     
                     if ([responseDict objectForKey:@"object"] != [NSNull null]) {
                         
                         array_Saloons = [responseDict objectForKey:@"object"];
                         
                     }
                     
                     _services = [[ServiceList initializeWithTutorialResponse:responseDict] mutableCopy];
                     
                     arrayFilteredResults = [NSArray arrayWithArray:_services];
                     
                     [self.servicesTable reloadData];
                     
                 }else if (sirFailed){
                     
                 }
             }];
        }
            break;
        case sOFFERS:
        {
            [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_OFFER spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
             {
                 
                 if (result == sirSuccess) {
                     
                     NSError *error = nil;
                     NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
                     
                     if ([responseDict objectForKey:@"object"] != [NSNull null]) {
                         
                         array_Saloons = [responseDict objectForKey:@"object"];
                         
                     }
                     _services = [[ServiceList initializeWithOffersResponse:responseDict] mutableCopy];
                     
                     arrayFilteredResults = [NSArray arrayWithArray:_services];
                     
                     [self.servicesTable reloadData];
                     
                 }else if (sirFailed){
                     
                 }
             }];
        }
            break;
            
        default:
            break;
    }
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

#pragma mark - TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return _services.count;
    return arrayFilteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *identifier =[self reuseIdentifier];
    ServiceCell *cell = (ServiceCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //ServiceList *service = _services[indexPath.row];
    ServiceList *service = arrayFilteredResults[indexPath.row];
    cell.name.text = service.saloonName;
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[service saloonId] integerValue]];
    
    NSArray *arrayResult = [array_favSaloons filteredArrayUsingPredicate:resultPredicate];
    
    if ((arrayResult != nil) && (arrayResult.count)) {
        cell.favourite.selected = YES;
    }
    else
        cell.favourite.selected = NO;

    
    if ([service.gender isEqualToString:@"M"]) {
        cell.genderImage.image = [UIImage imageNamed:@"ic_male"];
    }
    
    [cell.distance setTitle:[NSString stringWithFormat:@"%@ KM",service.saloonDstfrmCurrLocation] forState:UIControlStateNormal];
    if (service.saloonServices.count) {
        [cell.descriptionService setText:[service.saloonServices componentsJoinedByString:@","]];
    }
    
    [cell.address setText:service.saloonAddress];
    [cell.reviewCounts setTitle:[NSString stringWithFormat:@"%@ reviews",service.sallonReviewCount] forState:UIControlStateNormal];
    
    __weak LandingServicesViewController *selfWeak = self;
    
    [cell reviewWithCompletion:^(UIButton *sender, ServiceCollectionType serviceType){
        switch (serviceType) {
            
            case tReview:
                [selfWeak reviewPresent:indexPath];
                break;
            case tMenu:
                [selfWeak imageViewerPresent:service.menuImages];
                break;
            case tPhoto:
                [selfWeak imageViewerPresent:service.clubImages];// Dnt know what to show
                break;
            case tInfo:
                [selfWeak showSaloonInfo];
            case tCall:
                [selfWeak showCallingPopup:service.contacts];
            case tDistance:
                [selfWeak showDistancePopUp];
            default:
                break;
                
        }
    }];
        
    [cell.startRatingView setRating:[service.saloonRating doubleValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_menuListView.selectedButtonIndex == sOFFERS) {
        
        OfferDetailViewController *offerDetail = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OfferDetailViewController class])];
        [offerDetail setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:offerDetail animated:NO completion:^{
            
        }];
        
    }
    else{
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [UtilityClass showSpinnerWithMessage:@"" onView:nil];
        });
        
        LandingBriefViewController *landingBriefViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingBriefViewController"];
        [self.navigationController pushViewController:landingBriefViewController animated:YES];
        
        dispatch_after(0.3, dispatch_get_main_queue(), ^{
            //landingBriefViewController.service = _services[indexPath.row];
            landingBriefViewController.service = arrayFilteredResults[indexPath.row];

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
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[_services[indexPath.row] saloonId] integerValue]];
                
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
                    NSMutableArray *saloons = [[NSMutableArray alloc] initWithObjects:arrayFilteredResults[indexPath.row], nil];
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
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[_services[indexPath.row] saloonId] integerValue]];
                
                NSArray *arrayResult = [saloons filteredArrayUsingPredicate:resultPredicate];
                
                if ((arrayResult != nil) && (arrayResult.count)) {
                    // Do nothing
                }
                else
                {
                    
                    if (saloons.count <10) {
                        
                        // write Record:
                        //[saloons addObject:_services[indexPath.row]];
                        [saloons addObject:arrayFilteredResults[indexPath.row]];
                    }
                    else {
                        //[saloons replaceObjectAtIndex:saloons.count-1 withObject:_services[indexPath.row]];
                        [saloons replaceObjectAtIndex:saloons.count-1 withObject:arrayFilteredResults[indexPath.row]];
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

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (_menuListView.selectedButtonIndex) {
            
        case sTUTORIAL:
            return  192.0f;;
            
            break;

        case sOFFERS:
            return  192.0f;;
            
            break;

        default:
            return 152.0f;
            break;
    }
 
}

-(void)reviewPresent:(NSIndexPath*)index{
    
   __block ReviewViewController *review = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReviewViewController class])];
    //review.service = _services[index.row];
    review.service = arrayFilteredResults[index.row];

    [review setModalPresentationStyle:UIModalPresentationFormSheet];
    [review setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    CGRect rect = self.view.frame;
    rect.size.width = rect.size.width -20;
    rect.size.height = rect.size.height -20;
    [popoverController setPopoverContentSize:rect.size];
    popoverController = [[WYPopoverController alloc] initWithContentViewController:review];
    [popoverController presentPopoverAsDialogAnimated:YES completion:^{
        
    }];

}

-(void)showSaloonInfo {
    
    NSLog(@"show info");
    
}


-(void)showCallingPopup:(NSArray*)contacts {
    
    NSLog(@"Calling PopUp");

    if (contacts.count) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select number to call" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        for (NSString *number in contacts) {
            if (number.length == 10)
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
    
    NSString *phoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

-(void)showMenuPopUp {
    
    NSLog(@"Menu PopUp");

}


-(void)showDistancePopUp {
    
    NSLog(@"Distance PopUp");
    
}

-(void)imageViewerPresent:(NSArray*)images{
    if (images.count) {
        __block ImageViewerViewController *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];
        
        imageViewer.images = images;
        
        CGRect rect = self.view.frame;
        rect.size.width = rect.size.width- 40;
        rect.size.height = rect.size.height -60;
        
        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];
        [popoverController presentPopoverAsDialogAnimated:YES completion:^{
            
        }];
    }
    
}

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return menuItems.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return menuItems[index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    switch (index) {
        case sHAIR:
        {
            _serviceId = sHAIR;
            [self serviceLoad];
        }
            break;
        case sFACEBODY:
        {
            _serviceId = sFACEBODY;
            [self serviceLoad];
        }
            break;
        case sSPA:
        {
            _serviceId = sSPA;
            [self serviceLoad];
        }
            break;
        case sMAKEUPBRIDAL:
        {
            _serviceId = sMAKEUPBRIDAL;
            [self serviceLoad];
        }
            break;
        case sMEDISPA:
        {
            _serviceId = sMEDISPA;
            [self serviceLoad];
        }
            break;
        case sTATOOPIERCING:
        {
            _serviceId = sTATOOPIERCING;
            [self serviceLoad];
        }
            break;
        case sNAILS:
        {
            _serviceId = sNAILS;
            [self serviceLoad];
        }
            break;
        case sTUTORIAL:
        {
            _serviceId = sTUTORIAL;
            [self webServiceWithType:sTUTORIAL];
        }
            break;
        case sOFFERS:
        {
            _serviceId = sOFFERS;
            [self webServiceWithType:sOFFERS];

        }
            break;
  
        default:
            break;
    }
    [_servicesTable reloadData];
}

-(NSString*)reuseIdentifier{
    
    switch (_menuListView.selectedButtonIndex) {
        case sOFFERS:
            return  @"OfferCell";

            break;
            
        case sTUTORIAL:
            return  @"TutorialCell";

            break;
            
        default:
            return  @"ServiceCellIdentifier";
            break;
    }
    return nil;

}




- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}
- (IBAction)selectCity:(id)sender{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appdelegate selectCityActionWithController:self popverFroomRect:_cityName.frame CompletionHandler:^(NSString *cityName, NSIndexPath *indexPath) {
        [_cityName setTitle:cityName forState:UIControlStateNormal];
        
        [self serviceLoad];
    }];
}




- (void)setDDListHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0 : 180;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [_ddList.view setFrame:CGRectMake(0, self.searchBar.frame.origin.y + self.searchBar.frame.size.height, self.view.frame.size.width, height)];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark DropDownListPassValueDelegate protocol

-(void)firstRowSelectedWithValue:(id)value {
    if (value) {
        [self searchBarSearchButtonClicked:_searchBar];
        [self setDDListHidden:YES];
        
        NSMutableArray *array = (NSMutableArray*)value;
        [array removeObjectAtIndex:0];
        
        LandingServicesViewController *landingservice = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingServicesViewController"];
        //landingservice.serviceId = listObj.services;
        landingservice.services = [NSMutableArray arrayWithArray:array];
        landingservice.isComingFromSearch = YES;
        landingservice.selectedSegmentFromSearch = 0;
        [self.navigationController pushViewController:landingservice animated:YES];
    }
    else {
        
    }
}

-(void)didSelectRowWithObject:(id)object{
    
    _searchBar.text = nil;// objServiceList.saloonName;
    [self searchBarSearchButtonClicked:_searchBar];
    [self setDDListHidden:YES];
    
    if (object)
    {
        ServiceList *objServiceList = (ServiceList*)object;
        
        LandingBriefViewController *landingBriefViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingBriefViewController"];
        [self.navigationController pushViewController:landingBriefViewController animated:YES];
        
        dispatch_after(0.3, dispatch_get_main_queue(), ^{
            //landingBriefViewController.service = _services[indexPath.row];
            landingBriefViewController.service = objServiceList;
            
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
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[objServiceList saloonId] integerValue]];
                
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
                    NSMutableArray *saloons = [[NSMutableArray alloc] initWithObjects:objServiceList, nil];
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
                
                NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[objServiceList saloonId] integerValue]];
                
                NSArray *arrayResult = [saloons filteredArrayUsingPredicate:resultPredicate];
                
                if ((arrayResult != nil) && (arrayResult.count)) {
                    // Do nothing
                }
                else
                {
                    
                    if (saloons.count <10) {
                        
                        // write Record:
                        //[saloons addObject:_services[indexPath.row]];
                        [saloons addObject:objServiceList];
                    }
                    else {
                        //[saloons replaceObjectAtIndex:saloons.count-1 withObject:_services[indexPath.row]];
                        [saloons replaceObjectAtIndex:saloons.count-1 withObject:objServiceList];
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
    else {
        [UtilityClass showAlertwithTitle:nil message:@"some error occured, please try after some time."];
    }
}


#pragma mark - SearchBar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] != 0) {
        _ddList._searchText = searchText;
        //[_ddList updateData];
        [self setDDListHidden:NO];
    }
    else {
        [self setDDListHidden:YES];
    }
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString* searchText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    
    NSLog(@"%@",searchText);
    
    if (!isSearchReqQueued && (searchText.length == 4))
    {
        NSLog(@"Hit Web Service");
        //also check if already hit or not
        NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:(idCity!=nil ? idCity : @"1"),@"cityId",searchText,@"searchString",@"1",@"userId", nil];
        
        isSearchReqQueued = YES;
        
        [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_SEARCH spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
        {
            isSearchReqQueued = NO;
            
            if (result == sirSuccess) {
               
                NSError *error = nil;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
                
                if ([responseDict objectForKey:@"object"] != [NSNull null]) {
                    
                    [array_SearchResults removeAllObjects];
                    [array_SearchResults addObjectsFromArray:[responseDict objectForKey:@"object"]];
                }
                
                NSMutableArray *array_SearchedServices = [[ServiceList initializeWithResponse:responseDict] mutableCopy];
                
                [_ddList updateDataWithArray:array_SearchedServices];
                
            }else if (sirFailed){
            
            }
        }];
    }
    
    return YES;
}





@end
