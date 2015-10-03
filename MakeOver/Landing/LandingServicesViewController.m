//
//  LandingServicesViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "LandingServicesViewController.h"

#import "SearchResultsController.h"
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

#import "INTULocationManager.h"

@interface LandingServicesViewController (){
    WYPopoverController *popoverController;
    FilterViewController *filterViewController;
    
    NSMutableArray *arrayFilteredResults;
    BOOL isSortingByStylist;
}

@property (nonatomic, strong) NSMutableDictionary *filterParams;

@end

@implementation LandingServicesViewController


static NSArray *menuItems;

- (void)viewDidLoad {

    [super viewDidLoad];

    _nextPageNumber = 1;
    isPageLimitReached = NO;

    array_Saloons = [NSMutableArray new];
    self.services = [NSMutableArray new];
    array_searchResultsONFilteredItems = [NSMutableArray new];

    self.menuListView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    menuItems = @[@"HAIR SERVICE",@"FACE & BODY",@"SPA",@"MAKEUP & BRIDAL",@"MEDISPA",@"TATOO & PIERCING",@"NAILS",@"TUTORIALS",@"OFFERS"];

    self.menuListView.delegate = self;
    self.menuListView.dataSource = self;
    [self.menuListView setBackgroundColor:[UIColor clearColor]];
    [self.HTHorizontalView addSubview:self.menuListView];

    isFilterON = NO;
    [self.servicesTable reloadData];

    [self.menuListView reloadData];

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

        _menuListView.selectedButtonIndex = self.selectedSegmentFromSearch -1;
        
        arrayFilteredResults = [NSMutableArray arrayWithArray:_services];
        [self.servicesTable reloadData];
    }
    else {
        
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [ServiceInvoker sharedInstance].city!=nil? [_cityName setTitle:[ServiceInvoker sharedInstance].city.cityName forState:UIControlStateNormal]:NSLog(@"");
        
        arrayFilteredResults = [NSMutableArray new];
        array_SearchResults = [NSMutableArray new];
        
        _ddList = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
        _ddList._delegate = self;
        
        [_ddList.view setFrame:CGRectMake(0,self.searchBar.frame.origin.y + self.searchBar.frame.size.height, self.view.frame.size.width, 0)];
        [self.view addSubview:_ddList.view];
        
        if (!_serviceId)
            _serviceId = 1;
        
        if (_serviceId == 1) {
            [self serviceLoad];
            self.menuListView.selectedButtonIndex = _serviceId -1;
        }
        else
            [self.menuListView buttonWasTapped:[self.menuListView.buttons objectAtIndex:_serviceId -1]];
    }
    
}

- (void)viewDidLayoutSubviews {
    
    _cityName.imageEdgeInsets = UIEdgeInsetsMake(2, _cityName.frame.size.width-6, 0, 0);
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
    
//    __weak NSArray *weakArray = _services;
    
    __weak LandingServicesViewController *weakSelf = self;
    
    filterViewController.callback = ^(NSDictionary *params) {

        isFilterON = YES;

        NSString *sortingByFavouriteStylist   = [params objectForKey:@"sortByFavouriteStylist"];
        NSString *sortingByRating   = [params objectForKey:@"sortByRating"];
        NSString *sortingByDistance = [params objectForKey:@"sortByDistance"];


        NSString *str_isSorting = [params objectForKey:@"isSorting"];
        NSString *str_isFiltering = [params objectForKey:@"isFiltering"];
        NSString *str_isFilterChanged = [params objectForKey:@"isFilterChanged"];

        if ([str_isSorting isEqualToString:@"YES"] || [str_isFiltering isEqualToString:@"YES"])
            _isFilterSortApplied = YES;
        else if (![str_isSorting isEqualToString:@"YES"] || ![str_isFiltering isEqualToString:@"YES"]) {
            _isFilterSortApplied = NO;
            _isFiltersApplied = NO;
        }

        if (_isFilterSortApplied)
        {
            
            if ([str_isFiltering isEqualToString:@"YES"]
                && [str_isFilterChanged isEqualToString:@"YES"])
            {
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                
                parameters[@"serviceId"] = @(_serviceId);
                NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
                parameters[@"cityId"] = idCity!=nil ? idCity : @"1";
                
                NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];
                parameters[@"userId"] = string_userId!=nil ? string_userId : @"";
                
                NSString *filterBySex = [params objectForKey:@"filterBySex"];
                //NSString *filterByParticularTime = [params objectForKey:@"filterByTime"];
                NSString *filterByTimeRange = [params objectForKey:@"filterByRange"];
                NSString *filterByCreditCardHolders = [params objectForKey:@"filterByCardPresent"];
                
                NSMutableString *paramFilterBy = [NSMutableString new];
                if (filterBySex != nil && filterBySex.length != 0) {
                    [parameters setObject:filterBySex forKey:@"gender"];
                    [paramFilterBy appendString:@"gender/"];
                }
                
                if (filterByTimeRange != nil && filterByTimeRange.length != 0) {
                    NSString *str_startTime = [params objectForKey:@"filterByRange_lower"];
                    NSString *str_endTime = [params objectForKey:@"filterByRange_upper"];
                    
                    if (str_startTime  && ![str_startTime isEqualToString:@"0"])
                    {
                        [parameters setObject:str_startTime forKey:@"startTime"];
                    }
                    if (str_endTime && ![str_endTime isEqualToString:@"0"])
                    {
                        [parameters setObject:str_endTime forKey:@"endTime"];
                    }
                    
                    [paramFilterBy appendString:@"timeRange/"];
                }
                
                if (filterByCreditCardHolders != nil && filterByCreditCardHolders.length != 0 && ([filterByCreditCardHolders isEqualToString:@"Y"])) {
                    
                    [parameters setObject:filterByCreditCardHolders forKey:@"creditCardAvailable"];
                    [paramFilterBy appendString:@"creditCard"];
                }
                
                NSString *filterBy = [paramFilterBy stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
                
                [parameters setObject:filterBy forKey:@"filterBy"];

                self.filterParams = parameters;
                
                _nextPageNumber = 1;
                isPageLimitReached = NO;
                
                [self webServiceFilterResults];
                
                /*                NSPredicate *resultPredicate_gender;
                 NSPredicate *resultPredicate_time;
                 NSPredicate *resultPredicate_card;
                 
                 if (filterBySex != nil && filterBySex.length != 0) {
                 resultPredicate_gender = [NSPredicate predicateWithFormat:@"SELF.gender LIKE[c] %@",filterBySex];
                 }
                 
                 if (filterByTimeRange != nil && filterByTimeRange.length != 0) {
                 NSString *str_startTime = [params objectForKey:@"filterByRange_lower"];
                 NSString *str_endTime = [params objectForKey:@"filterByRange_upper"];
                 
                 resultPredicate_time = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"%@ >= SELF.startTimeDecimal",str_startTime],[NSPredicate predicateWithFormat:@"SELF.endTimeDecimal >= %@",str_endTime]]];;
                 }
                 
                 if (filterByCreditCardHolders != nil && filterByCreditCardHolders.length != 0 && ([filterByCreditCardHolders isEqualToString:@"Y"])) {
                 resultPredicate_card = [NSPredicate predicateWithFormat:@"SELF.creditDebitCardSupport LIKE[c] %@",filterByCreditCardHolders];
                 }
                 
                 NSMutableArray *array = [NSMutableArray new];
                 
                 if (resultPredicate_gender != nil) {
                 [array addObject:resultPredicate_gender];
                 }
                 if (resultPredicate_time != nil) {
                 [array addObject:resultPredicate_time];
                 }
                 if (resultPredicate_card != nil) {
                 [array addObject:resultPredicate_card];
                 }
                 
                 NSPredicate *multiplePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:array];
                 
                 for (id service in weakArray) {
                 ServiceList *serviceListObj = (ServiceList*)service;
                 NSLog(@"gender = %@",serviceListObj.gender);
                 NSLog(@"startTime = %@ endTime = %@",serviceListObj.startTimeDecimal,serviceListObj.endTimeDecimal);
                 NSLog(@"card = %@",serviceListObj.creditDebitCardSupport);
                 NSLog(@"***********************************************");
                 }
                 
                 arrayFilteredResults = [NSMutableArray arrayWithArray:[weakArray filteredArrayUsingPredicate:multiplePredicate]];
                 */
            }
            
            if ([str_isSorting isEqualToString:@"YES"]) {
                
                isSortingByStylist = NO;
                self.isFiltersApplied = NO;
                
                if (sortingByRating != nil && sortingByRating.length != 0 && [sortingByRating isEqualToString:@"YES"]) {
                    
                    
                    NSArray *sortedArray;
                    sortedArray = [arrayFilteredResults sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                        NSNumber *first = [(ServiceList*)a saloonRating];
                        NSNumber *second = [(ServiceList*)b saloonRating];
                        return [second compare:first];
                    }];
                    
                    arrayFilteredResults = [sortedArray mutableCopy];
                    
                    [weakSelf.servicesTable reloadData];
                }
                
                
                if (sortingByDistance != nil && sortingByDistance.length != 0 && [sortingByDistance isEqualToString:@"YES"]) {
                    
                    NSArray *sortedArray;
                    sortedArray = [arrayFilteredResults sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                        NSNumber *first = [NSNumber numberWithFloat:[[(ServiceList*)a saloonDstfrmCurrLocation] floatValue]] ;
                        NSNumber *second = [NSNumber numberWithFloat:[[(ServiceList*)b saloonDstfrmCurrLocation] floatValue]];
                        return [first compare:second];
                    }];
                    
                    arrayFilteredResults = [sortedArray mutableCopy];
                    
                    [weakSelf.servicesTable reloadData];
                }
                
                
                if (sortingByFavouriteStylist != nil && sortingByFavouriteStylist.length != 0 && [sortingByFavouriteStylist isEqualToString:@"YES"]) {
                    
                    _nextPageNumber = 1;
                    isPageLimitReached = NO;
                    
                    isSortingByStylist = YES;
                    [weakSelf webServiceSortByStylist];
                }
                
                array_searchResultsONFilteredItems = [[NSMutableArray alloc]initWithArray:arrayFilteredResults];
                [weakSelf.servicesTable reloadData];
            }

        }
        else { // load data for selected category
            
            [array_searchResultsONFilteredItems removeAllObjects];
            [self.servicesTable reloadData];
            
            [self selectionList:_menuListView didSelectButtonWithIndex:_menuListView.selectedButtonIndex];

        }
        
    };
}

-(void)serviceLoad {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    parameters[@"serviceId"] = @(_serviceId);
    NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    parameters[@"cityId"] = idCity!=nil ? idCity : @"1";
    
    NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];
    parameters[@"userId"] = string_userId!=nil ? string_userId : @"";
    
    NSString *pageNumberString = [NSString stringWithFormat:@"%ld",(long)_nextPageNumber];
    [parameters setObject:pageNumberString forKey:@"pageNo"];
    
    NSString *loadingMessage;
    if (_nextPageNumber == 1) {
        loadingMessage = @"Fetching List...";
        
        [array_Saloons removeAllObjects];
        [_services removeAllObjects];
        [arrayFilteredResults removeAllObjects];
        
        [self.servicesTable reloadData];
    }
    else
        loadingMessage = nil;//@"Fetching more results...";
    
    
    __block CLLocationCoordinate2D location = [ServiceInvoker sharedInstance].coordinate;
    
    if (self.tabBarController.selectedIndex == 1)
    {
        INTULocationServicesState authorizationState = [INTULocationManager locationServicesState];
        
        if (authorizationState == INTULocationServicesStateDenied
            || authorizationState == INTULocationServicesStateDisabled
            || authorizationState == INTULocationServicesStateRestricted)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location services are off"
                                                                message:@"To see nearby saloons you must turn on the Location Services from Settings."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles: nil];
            [alertView show];
            
            return;
        }
        else if (authorizationState == INTULocationServicesStateAvailable
                 && (location.latitude != 0 || location.longitude != 0))
        {
            parameters[@"curr_lat"] =[NSString stringWithFormat:@"%f",location.latitude];//:@"28.089";
            parameters[@"curr_Long"] =[NSString stringWithFormat:@"%f",location.longitude];// @"77.986";
            
            [self fetchNearbySaloonsWithParams:parameters spinningMessage:loadingMessage];
            
            return;
        }
        else
        {
            [UtilityClass showSpinnerWithMessage:@"getting your location..." onView:nil];

            INTULocationManager *locMgr = [INTULocationManager sharedInstance];
            [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                               timeout:3
                                  delayUntilAuthorized:YES
                                                 block:
             ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status)
            {

                [UtilityClass removeHudFromView:nil afterDelay:0];
                
                 if (status == INTULocationStatusSuccess) {
                     
                     location = [ServiceInvoker sharedInstance].coordinate = currentLocation.coordinate;
                     // achievedAccuracy is at least the desired accuracy (potentially better)
                     
                     parameters[@"curr_lat"] =[NSString stringWithFormat:@"%f",location.latitude];//:@"28.089";
                     parameters[@"curr_Long"] =[NSString stringWithFormat:@"%f",location.longitude];// @"77.986";
                     
                     [self fetchNearbySaloonsWithParams:parameters spinningMessage:loadingMessage];
                     
                 }
                 else if (status == INTULocationStatusTimedOut) {
                     // You may wish to inspect achievedAccuracy here to see if it is acceptable, if you plan to use currentLocation
                     location = [ServiceInvoker sharedInstance].coordinate = currentLocation.coordinate;
                     
                     parameters[@"curr_lat"] =[NSString stringWithFormat:@"%f",location.latitude];//:@"28.089";
                     parameters[@"curr_Long"] =[NSString stringWithFormat:@"%f",location.longitude];// @"77.986";

                     [self fetchNearbySaloonsWithParams:parameters spinningMessage:loadingMessage];

                 }
                 else {
                     // An error occurred
                     
                 }
                 
             }];
            
            return;

        }
    }

    
    
    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_SALOONS spinningMessage:loadingMessage
        completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
        {
            [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] stopAnimating];
            loadMoreView.hidden = YES;

            if (result == sirSuccess)
            {
                NSError *error = nil;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
                
                if ([responseDict objectForKey:@"object"] != [NSNull null])
                {
                    
                    NSInteger recordsCount = [[responseDict objectForKey:@"object"] count];
                    
                    if (recordsCount < 10)
                        isPageLimitReached = YES;
                    
                    if (recordsCount) {
                        
                        [array_Saloons addObjectsFromArray:[responseDict objectForKey:@"object"]];
                        
                        [_services addObjectsFromArray:[ServiceList initializeWithResponse:responseDict]];
                        
                        arrayFilteredResults = [_services mutableCopy];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.servicesTable reloadData];
                        });
                        
                        _nextPageNumber++;
                    }
                    else if (_nextPageNumber == 1)
                        [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                    else {
                        isPageLimitReached = YES;
                    }
                }
                else
                    [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                
                isFilterON = NO;
            }
            else {
//                [self.servicesTable reloadData];
            }

    }];

//    [self.servicesTable reloadData];
    
    [AppDelegate resetSortNfilter];

}

- (void)fetchNearbySaloonsWithParams:(NSDictionary*)parameters spinningMessage:(NSString*)loadingMessage {
    
    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_SALOONS spinningMessage:loadingMessage
                                                      completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
     {
         [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] stopAnimating];
         loadMoreView.hidden = YES;

         if (result == sirSuccess)
         {
             NSError *error = nil;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
             
             if ([responseDict objectForKey:@"object"] != [NSNull null])
             {
                 
                 NSInteger recordsCount = [[responseDict objectForKey:@"object"] count];
                 
                 if (recordsCount < 10)
                     isPageLimitReached = YES;
                 
                 if (recordsCount) {
                     
                     [array_Saloons addObjectsFromArray:[responseDict objectForKey:@"object"]];
                     
                     [_services addObjectsFromArray:[ServiceList initializeWithResponse:responseDict]];
                     
                     arrayFilteredResults = [_services mutableCopy];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.servicesTable reloadData];
                     });
                     
                     _nextPageNumber++;
                 }
                 else if (_nextPageNumber == 1)
                     [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                 else {
                     isPageLimitReached = YES;
                 }
             }
             else
                 [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
             
             isFilterON = NO;
         }
         else {
             //                [self.servicesTable reloadData];
         }
         
     }];
    
    //    [self.servicesTable reloadData];
    
    [AppDelegate resetSortNfilter];
}

- (void)webServiceFilterResults {
    
    self.isFiltersApplied = YES;
    
    NSMutableDictionary *parameters = [self.filterParams mutableCopy];
    
    NSString *pageNumberString = [NSString stringWithFormat:@"%ld",(long)_nextPageNumber];
    [parameters setObject:pageNumberString forKey:@"pageNo"];
    
    NSString *loadingMessage;
    if (_nextPageNumber == 1) {
        loadingMessage = @"Fetching List...";
        
        [array_Saloons removeAllObjects];
        [_services removeAllObjects];
        [arrayFilteredResults removeAllObjects];
        
        [self.servicesTable reloadData];
    }
    else
        loadingMessage = nil;//@"Fetching more results...";
    
    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_FILTER spinningMessage:loadingMessage
                                                      completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
     {
         [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] stopAnimating];
         loadMoreView.hidden = YES;
         
         if (result == sirSuccess)
         {
             NSError *error = nil;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
             
             if ([responseDict objectForKey:@"object"] != [NSNull null])
             {
                 
                 NSInteger recordsCount = [[responseDict objectForKey:@"object"] count];
                 
                 if (recordsCount < 10)
                     isPageLimitReached = YES;
                 
                 if (recordsCount) {
                     
                     [array_Saloons addObjectsFromArray:[responseDict objectForKey:@"object"]];
                     
                     [_services addObjectsFromArray:[ServiceList initializeWithResponse:responseDict]];
                     
                     arrayFilteredResults = [_services mutableCopy];
                     
                     array_searchResultsONFilteredItems = [[NSMutableArray alloc] initWithArray:arrayFilteredResults];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.servicesTable reloadData];
                     });
                     
                     _nextPageNumber++;
                 }
                 else if (_nextPageNumber == 1)
                     [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                 else {
                     isPageLimitReached = YES;
                 }
             }
             else
                 [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
        }
        else {
             // [self.servicesTable reloadData];
        }
         
     }];
}

-(void)webServiceSortByStylist {
    
    NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];
    string_userId = string_userId!=nil ? string_userId : @"";

    NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    idCity = idCity!=nil ? idCity : @"1";

    NSString *pageNumberString = [NSString stringWithFormat:@"%ld",(long)_nextPageNumber];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:idCity,@"cityId",[NSString stringWithFormat:@"%ld",(long)_serviceId],@"serviceId",string_userId,@"userId",pageNumberString,@"pageNo", nil];
    
    NSString *loadingMessage;
    if (_nextPageNumber == 1) {
        loadingMessage = @"Fetching List...";
        
        [array_Saloons removeAllObjects];
        [_services removeAllObjects];
        [arrayFilteredResults removeAllObjects];
        
        [self.servicesTable reloadData];
    }
    else
        loadingMessage = nil;//@"Fetching more results...";


    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_FAV_STYLIST spinningMessage:loadingMessage completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
     {
         [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] stopAnimating];
         loadMoreView.hidden = YES;

         if (result == sirSuccess)
         {
             
             NSError *error = nil;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
             
             if ([responseDict objectForKey:@"object"] != [NSNull null])
             {
                 
                 NSInteger recordsCount = [[responseDict objectForKey:@"object"] count];
                 
                 if (recordsCount < 10)
                     isPageLimitReached = YES;
                 
                 if (recordsCount) {
                     
                     [array_Saloons addObjectsFromArray:[responseDict objectForKey:@"object"]];
                     
                     [_services addObjectsFromArray:[ServiceList initializeWithResponse:responseDict]];
                     
                     arrayFilteredResults = [_services mutableCopy];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.servicesTable reloadData];
                     });

                     _nextPageNumber++;
                 }
                 else if (_nextPageNumber == 1)
                     [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                 else {
                     isPageLimitReached = YES;
                 }
             }
             else
                 [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];

             
             isFilterON = NO;
         }
         else {
             // [self.servicesTable reloadData];
             [UtilityClass showAlertwithTitle:@"No result found!" message:nil];
         }

//         [self.servicesTable reloadData];

     }];
}


-(void)webServiceWithType:(MenuServiceType)serviceType{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    parameters[@"cityId"] = idCity!=nil ? idCity : @"1";

    NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];
    NSString *userId = string_userId!=nil ? string_userId : @"";

    [parameters setObject:userId forKey:@"userId"];
    
    NSString *pageNumberString = [NSString stringWithFormat:@"%ld",(long)_nextPageNumber];
    [parameters setObject:pageNumberString forKey:@"pageNo"];
    
    NSString *loadingMessage;
    if (_nextPageNumber == 1) {
        loadingMessage = @"Fetching List...";
        
        [array_Saloons removeAllObjects];
        [_services removeAllObjects];
        [arrayFilteredResults removeAllObjects];
        
        [self.servicesTable reloadData];
    }
    else
        loadingMessage = nil;//@"Fetching more results...";

    switch (serviceType) {
            
        case sTUTORIAL:
        {
            [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_TUTORIAL spinningMessage:loadingMessage completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
             {
                 [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] stopAnimating];
                 loadMoreView.hidden = YES;
                 
                 if (result == sirSuccess) {
                     
                     NSError *error = nil;
                     NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
                     
                     if ([responseDict objectForKey:@"object"] != [NSNull null])
                     {
                         NSInteger recordsCount = [[responseDict objectForKey:@"object"] count];
                         
                         if (recordsCount < 10)
                             isPageLimitReached = YES;
                         
                         if (recordsCount) {
                             
                             [array_Saloons addObjectsFromArray:[responseDict objectForKey:@"object"]];
                             
                             [_services addObjectsFromArray:[ServiceList initializeWithTutorialResponse:responseDict]];
                             
                             arrayFilteredResults = [_services mutableCopy];
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self.servicesTable reloadData];
                             });
                             
                             _nextPageNumber++;
                         }
                         else if (_nextPageNumber == 1)
                             [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                         else {
                             isPageLimitReached = YES;
                         }
                     }
                     else
                         [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];

                     
                     isFilterON = NO;
                 }
                 else {
//                     [self.servicesTable reloadData];
                     [UtilityClass showAlertwithTitle:@"No result found!" message:nil];
                 }

             }];
        }
            break;
            
        case sOFFERS:
        {
            [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_OFFER spinningMessage:loadingMessage completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
             {
                 [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] stopAnimating];
                 loadMoreView.hidden = YES;

                 if (result == sirSuccess) {
                     
                     NSError *error = nil;
                     NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
                     
                     if ([responseDict objectForKey:@"object"] != [NSNull null])
                     {
                         
                         NSInteger recordsCount = [[responseDict objectForKey:@"object"] count];
                         
                         if (recordsCount < 10)
                             isPageLimitReached = YES;
                         
                         if (recordsCount) {
                             
                             [array_Saloons addObjectsFromArray:[responseDict objectForKey:@"object"]];
                             
                             [_services addObjectsFromArray:[ServiceList initializeWithOffersResponse:responseDict]];
                             
                             arrayFilteredResults = [_services mutableCopy];
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self.servicesTable reloadData];
                             });
                             
                             _nextPageNumber++;
                         }
                         else if (_nextPageNumber == 1)
                             [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                         else {
                             isPageLimitReached = YES;
                         }
                     }
                     else
                         [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];

                     
                     isFilterON = NO;
                 }
                 else {
//                     [self.servicesTable reloadData];
                     [UtilityClass showAlertwithTitle:@"No result found!" message:nil];
                 }

             }];
        }
            break;
            
        default:
            break;
    }
    
    [AppDelegate resetSortNfilter];
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

    if (isFilterON) {

        return array_searchResultsONFilteredItems.count;

    }else{

        return arrayFilteredResults.count;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier =[self reuseIdentifier];

    ServiceCell *cell = (ServiceCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    ServiceList *service;

    if (isFilterON) {

        service = array_searchResultsONFilteredItems[indexPath.row];

    }else{

        service = arrayFilteredResults[indexPath.row];

    }

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
        cell.genderImage2.hidden = YES;

        if ([identifier isEqualToString:@"OfferCell"]) {
            cell.constraint_leading_offer.constant =  3;
        }else if ([identifier isEqualToString:@"TutorialCell"]){
            cell.constraint_leading_tutorial.constant =  3;
        }else{
            cell.constraint_leading.constant =  3;
        }

        UIButton *button = (UIButton*)[cell viewWithTag:43];
        [button updateConstraints];
        [cell updateConstraints];

    }else if ([service.gender isEqualToString:@"F"]) {
        cell.genderImage.image = [UIImage imageNamed:@"ic_female"];
        cell.genderImage2.hidden = YES;

        if ([identifier isEqualToString:@"OfferCell"]) {
            cell.constraint_leading_offer.constant =  3;
        }else if ([identifier isEqualToString:@"TutorialCell"]){
            cell.constraint_leading_tutorial.constant =  3;
        }else{
            cell.constraint_leading.constant =  3;
        }

        UIButton *button = (UIButton*)[cell viewWithTag:43];
        [button updateConstraints];
        [cell updateConstraints];

    }else if ([service.gender isEqualToString:@"U"]) {
        cell.genderImage.image = [UIImage imageNamed:@"ic_female"];
        cell.genderImage2.image = [UIImage imageNamed:@"ic_male"];
        cell.genderImage2.hidden = NO;

        if ([identifier isEqualToString:@"OfferCell"]) {
            cell.constraint_leading_offer.constant =  cell.genderImage2.frame.size.width + 3;
        }else if ([identifier isEqualToString:@"TutorialCell"]){
            cell.constraint_leading_tutorial.constant =  cell.genderImage2.frame.size.width + 3;
        }else{
            cell.constraint_leading.constant =  cell.genderImage2.frame.size.width + 3;
        }

        UIButton *button = (UIButton*)[cell viewWithTag:43];
        [button updateConstraints];
        [cell updateConstraints];

    }


    [cell.distance setTitle:[NSString stringWithFormat:@"%@ KM",service.saloonDstfrmCurrLocation] forState:UIControlStateNormal];
    if (service.saloonServices.count) {
        [cell.descriptionService setText:[service.saloonServices componentsJoinedByString:@","]];
    }
    
    //[cell.address setText:service.saloonAddress];
    [cell.address setText:service.saloonMainArea];

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
                
                [UtilityClass showAlertwithTitle:nil message:service.saloonInfo];
                
                break;
                
            case tCall:
                [selfWeak showCallingPopup:service.contacts];
                break;
                
            case tDistance:
                [selfWeak navigationButtonPressed:indexPath];
                break;
                
            default:
                break;
                
        }
    }];
        
    [cell.startRatingView setRating:[service.saloonRating doubleValue]];


    if ([identifier isEqualToString:@"OfferCell"]) {
        [cell.btn_showOffers addTarget:self action:@selector(showOffersPopUp:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_showOffers setTag:indexPath.row];
    }else if ([identifier isEqualToString:@"TutorialCell"]){
        [cell.btn_showTutorials addTarget:self action:@selector(showTutorialPopUp:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_showTutorials setTag:indexPath.row];
    }
    
    
    
    // ******* | PAGINATION LOGIC| ******** //

/*    if (!_isFilterSortApplied && !isPageLimitReached) // make pagination request else don't make request
    {
        NSInteger rows;

        if (isFilterON)
            rows = array_searchResultsONFilteredItems.count;
        else
            rows = arrayFilteredResults.count;

        if (rows-1 == indexPath.row)
        {
            switch (_menuListView.selectedButtonIndex)
            {
                  
                case 7:
                {
                    _serviceId = sTUTORIAL;
                    [self webServiceWithType:sTUTORIAL];
                }
                    break;
                    
                case 8:
                {
                    _serviceId = sOFFERS;
                    [self webServiceWithType:sOFFERS];
                }
                    break;

                default: {
                    [self serviceLoad];
                }
                
                    break;
            }
        }
    }
    else if (isSortingByStylist && !isPageLimitReached) {
        
        NSInteger rows;
        
        if (isFilterON)
            rows = array_searchResultsONFilteredItems.count;
        else
            rows = arrayFilteredResults.count;
        
        if (rows-1 == indexPath.row)
            [self webServiceSortByStylist];
    }
*/
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    loadMoreView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"loadMoreFooter"];
    
    if (!loadMoreView) {
        
        UIActivityIndicatorView *activityIndic = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)- 96, 11, 22, 22)];
        activityIndic.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        activityIndic.tag = 21;
        [activityIndic startAnimating];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(activityIndic.frame.origin.x +30, 11, self.view.bounds.size.width, 22.0)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = @"Fetching more saloons...";
        
        loadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [loadMoreView addSubview:label];
        [loadMoreView addSubview:activityIndic];
        loadMoreView.backgroundColor = [UIColor clearColor];
    }
    
    loadMoreView.hidden = YES;
    
    return loadMoreView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSArray *visibleRowIndexPaths = [_servicesTable indexPathsForVisibleRows];
    NSIndexPath *iPath = [visibleRowIndexPaths lastObject];
    
    NSLog(@"indexpath.row = %li",(long)iPath.row);
    
    // ******* | PAGINATION LOGIC| ******** //
    
    // If last row and more records available
    if (!isPageLimitReached && (iPath.row == [_servicesTable numberOfRowsInSection:0] -1))
    {
        
        if (!_isFilterSortApplied) {
            
            [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] startAnimating];
            loadMoreView.hidden = NO;

            switch (_menuListView.selectedButtonIndex)
            {
                case 7:
                {
                    _serviceId = sTUTORIAL;
                    [self webServiceWithType:sTUTORIAL];
                }
                    break;
                    
                case 8:
                {
                    _serviceId = sOFFERS;
                    [self webServiceWithType:sOFFERS];
                }
                    break;
                    
                default: {
                    [self serviceLoad];
                }
                    
                    break;
            }
        }
        else if (isSortingByStylist) {
            
            [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] startAnimating];
            loadMoreView.hidden = NO;

            [self webServiceSortByStylist];
        }
        else if (self.isFiltersApplied) {
            [(UIActivityIndicatorView*)[loadMoreView viewWithTag:21] startAnimating];
            loadMoreView.hidden = NO;
            
            [self webServiceFilterResults];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_menuListView.selectedButtonIndex == sOFFERS) {
        
        OfferDetailViewController *offerDetail = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OfferDetailViewController class])];
        [offerDetail setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentViewController:offerDetail animated:NO completion:^{
            
        }];
        
    }
    else
    {
        // Navigate to Landing Brief VC to display details
        LandingBriefViewController *landingBriefViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingBriefViewController"];

        if (isFilterON) {

            landingBriefViewController.service = array_searchResultsONFilteredItems[indexPath.row];

        }else{

            landingBriefViewController.service = arrayFilteredResults[indexPath.row];

        }

        [self.navigationController pushViewController:landingBriefViewController animated:YES];

    }

}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (_serviceId) {

        case sTUTORIAL:
            return  212.0f;

            break;

        case sOFFERS:
            return  212.0f;

            break;

        default:
            return 172.0f;
            break;
    }

}


-(void)showOffersPopUp:(id)sender {

    NSLog(@"Offer index %d",[sender tag]);

    ServiceList *service;

    if (isFilterON) {
        service = array_searchResultsONFilteredItems[[sender tag]];
    }else{
        service = arrayFilteredResults[[sender tag]];
    }

    if ([service.extraParams isKindOfClass:[NSDictionary class]]) {

        NSDictionary *dictOffer = [service.extraParams objectForKey:@"offer"];

        __block ImageViewerViewController *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];

        CGRect rect = [UIScreen mainScreen].bounds;

        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];
        if ([[dictOffer objectForKey:@"offerType"] isEqualToString:@"TEXT"]) {
            imageViewer.isTextDescription = YES;
            imageViewer.text_description = [dictOffer objectForKey:@"offerDesc"];
            imageViewer.images = [NSArray new];
        }else if ([[dictOffer objectForKey:@"offerType"] isEqualToString:@"IMAGE"]){
            imageViewer.isTextDescription = NO;
            imageViewer.images = [NSArray arrayWithObject:[dictOffer objectForKey:@"offerDesc"]]; // only one image url will be in offer
        }
        [popoverController presentPopoverAsDialogAnimated:YES completion:nil];

        imageViewer.callbackCancel = ^(void) {
            [popoverController dismissPopoverAnimated:YES];
        };

    }else{
        [UtilityClass showAlertwithTitle:nil message:@"Currently No Offer available"];
    }

}

-(void)showTutorialPopUp:(id)sender {

    NSLog(@"Tutorial index %d",[sender tag]);

    ServiceList *service;

    if (isFilterON) {
        service = array_searchResultsONFilteredItems[[sender tag]];
    }else{
        service = arrayFilteredResults[[sender tag]];
    }

    if ([service.extraParams isKindOfClass:[NSDictionary class]]) {

        NSDictionary *dictTutorial = service.extraParams;


        __block ImageViewerViewController *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];

        CGRect rect = [UIScreen mainScreen].bounds;

        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];

        if ([[dictTutorial objectForKey:@"tutType"] isEqualToString:@"TEXT"]) {
            imageViewer.isTextDescription = YES;
            imageViewer.text_description = [dictTutorial objectForKey:@"tutDesc"];
            imageViewer.images = [NSArray new];
        }else if ([[dictTutorial objectForKey:@"tutType"] isEqualToString:@"IMAGE"]){
            imageViewer.isTextDescription = NO;
            imageViewer.images = [dictTutorial objectForKey:@"images"];
        }

        [popoverController presentPopoverAsDialogAnimated:YES completion:nil];

        imageViewer.callbackCancel = ^(void) {
            [popoverController dismissPopoverAnimated:YES];
        };

    }else{
        [UtilityClass showAlertwithTitle:nil message:@"Currently No Tutorial available"];
    }

}

-(void)reviewPresent:(NSIndexPath*)index{
    
   __block ReviewViewController *review = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReviewViewController class])];

    if (isFilterON) {
        review.service = array_searchResultsONFilteredItems[index.row];
    }else{
        review.service = arrayFilteredResults[index.row];
    }

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


-(void)showCallingPopup:(NSArray*)contacts {
    
    NSLog(@"Calling PopUp");

    if (contacts.count) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select number to call" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        for (NSString *number in contacts) {
                [actionSheet addButtonWithTitle:number];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        
        [actionSheet setCancelButtonIndex:contacts.count];
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    else {
        [UtilityClass showAlertwithTitle:@"" message:@"Contact number not available for this saloon."];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
        NSString *phoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}

-(void)showMenuPopUp {
    
    NSLog(@"Menu PopUp");

}



-(void)imageViewerPresent:(NSArray*)images{
   
    if (images.count) {
        __block ImageViewerViewController *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];
        
        imageViewer.images = images;
        
        CGRect rect = [UIScreen mainScreen].bounds;
//        rect.size.width = rect.size.width - 40;
//        rect.size.height = rect.size.height - 60;

        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];
        [popoverController presentPopoverAsDialogAnimated:YES completion:^{
            
        }];

        imageViewer.callbackCancel = ^(void) {
            [popoverController dismissPopoverAnimated:YES];
        };
    }
    else
        [UtilityClass showAlertwithTitle:nil message:@"Sorry! No images available for the selected Item."];
}

#pragma mark- Menulist Items Datasource & Delegate
- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return menuItems.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return menuItems[index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
  
    _nextPageNumber = 1;
    isPageLimitReached = NO;
    
    switch (index) {
        case 0:
        {
            _serviceId = sHAIR;
            [self serviceLoad];
        }
            break;
        case 1:
        {
            _serviceId = sFACEBODY;
            [self serviceLoad];
        }
            break;
        case 2:
        {
            _serviceId = sSPA;
            [self serviceLoad];
        }
            break;
        case 3:
        {
            _serviceId = sMAKEUPBRIDAL;
            [self serviceLoad];
        }
            break;
        case 4:
        {
            _serviceId = sMEDISPA;
            [self serviceLoad];
        }
            break;
        case 5:
        {
            _serviceId = sTATOOPIERCING;
            [self serviceLoad];
        }
            break;
        case 6:
        {
            _serviceId = sNAILS;
            [self serviceLoad];
        }
            break;
        case 7:
        {
            _serviceId = sTUTORIAL;
            [self webServiceWithType:sTUTORIAL];
        }
            break;
        case 8:
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
    
    switch (_menuListView.selectedButtonIndex +1) {
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
        _nextPageNumber = 1;
        isPageLimitReached = NO;
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
        /*
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
         */
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

        NSDictionary *dict = (NSDictionary*)object;
        
        NSString *searchKey = [dict objectForKey:@"searchKey"];
        NSString *searchValue,*searchHelper = nil;
        
        if ([searchKey isEqualToString:@"saloon_name"]) {
            
            searchValue = [dict objectForKey:@"searchValue"];
            searchHelper = [dict objectForKey:@"searchHelper"];
        }
        else if ([searchKey isEqualToString:@"saloon_address"])
        {
            searchValue = [dict objectForKey:@"searchHelper"];
            searchHelper = [dict objectForKey:@"searchValue"];
        }
        else { // main_area
            searchValue = [dict objectForKey:@"searchValue"];
            searchHelper = @"";
        }
        
        NSArray *arrayServices = nil;
        id services = [dict objectForKey:@"services"];
        if ([services isKindOfClass:[NSString class]]) {
            arrayServices = [services componentsSeparatedByString:@","];
        }
        
        NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];
        
        NSString *userId = string_userId!=nil ? string_userId : @"";
        
        NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:(idCity!=nil ? idCity : @"1"),@"cityId",searchKey,@"searchKey",searchValue,@"searchValue",searchHelper,@"searchHelper",userId,@"userId", nil];
        
        // Navigate to Landing Brief VC to display details
        SearchResultsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsController"];
        controller.requestParams = parameters;
        controller.searcheSaloonServices = [arrayServices mutableCopy];
        controller.defaultServiceName = [menuItems objectAtIndex:_menuListView.selectedButtonIndex];
        controller.defaultServiceId = self.serviceId;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else {
        [UtilityClass showAlertwithTitle:nil message:@"some error occured, please try after some time."];
    }

}


#pragma mark - SearchBar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if (isFilterON) {

        
        
    } else {


        if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0) {
            _ddList._searchText = searchText;
            //[_ddList updateData];
            [self setDDListHidden:NO];
        }
        else {
            [self setDDListHidden:YES];
        }


    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (isFilterON) {
            array_searchResultsONFilteredItems=nil;
            array_searchResultsONFilteredItems = [NSMutableArray arrayWithArray:arrayFilteredResults];
            [_servicesTable reloadData];
        searchBar.text = @"";
    }

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
    NSString* searchText = [[searchBar.text stringByReplacingCharactersInRange:range withString:text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSLog(@"%@",searchText);

    if (isFilterON) {

        [self filterContentForSearchText:searchText];

    }
    else if (searchText.length && !(searchText.length/2 == 0))
    {
        if (isSearchReqQueued) {
            [[ServiceInvoker sharedInstance] cancelOperationFromQueue];
        }
        
        NSLog(@"d");
        //also check if already hit or not
        NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:(idCity!=nil ? idCity : @"1"),@"cityId",searchText,@"searchString", nil];
        
        isSearchReqQueued = YES;
        
        [self performSelector:@selector(makeSearchRequestWithParams:) withObject:parameters afterDelay:0.1];
    }


    return YES;
}

- (void)makeSearchRequestWithParams:(NSDictionary*)params {
    
    [[ServiceInvoker sharedInstance] setRequestTypeSearch];
    
    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:params requestAPI:API_KEY_SEARCH spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
     {
         isSearchReqQueued = NO;
         
         if (result == sirSuccess) {
             
             NSError *error = nil;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
             
             if ([responseDict objectForKey:@"object"] != [NSNull null]) {
                 
                 [array_SearchResults removeAllObjects];
                 [array_SearchResults addObjectsFromArray:[responseDict objectForKey:@"object"]];
             }
             
             [_ddList updateDataWithArray:array_SearchResults];
             
         }else if (sirFailed){
             
         }
     }];
}



- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText.length == 0 && [searchText isEqualToString:@""])
    {
        array_searchResultsONFilteredItems=nil;
        array_searchResultsONFilteredItems = [NSMutableArray arrayWithArray:arrayFilteredResults];
        [_servicesTable reloadData];
    }
    else
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonName CONTAINS [c] %@", searchText];//

        array_searchResultsONFilteredItems=nil;

        array_searchResultsONFilteredItems = [NSMutableArray arrayWithArray:[arrayFilteredResults filteredArrayUsingPredicate:resultPredicate]];

        [_servicesTable reloadData];
    }
}

#pragma mark- Maps

//ye apple ka tha.........
//*************************************
-(IBAction)navigationButtonPressed:(NSIndexPath*)index{
    
    ServiceList *service;

    if (isFilterON) {
        service = array_searchResultsONFilteredItems[index.row];
    }else{
        service = arrayFilteredResults[index.row];
    }

    if (service.saloonLat.length && service.saloonLong.length) {
        
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]])
        {
            NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?daddr=%@,%@&zoom=14&directionsmode=driving",service.saloonLat,service.saloonLong];
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:urlString]];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@",service.saloonLat,service.saloonLong];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }
    }
    else {
        [UtilityClass showAlertwithTitle:nil message:@"Directions unavailable for this location."];
    }
    
    
}


@end
