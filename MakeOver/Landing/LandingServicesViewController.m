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

@interface LandingServicesViewController (){
    WYPopoverController *popoverController;
    FilterViewController *filterViewController;
    
    NSArray *arrayFilteredResults;
    BOOL isSortingByStylist;
}

@end

@implementation LandingServicesViewController


static NSArray *menuItems;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.menuListView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    menuItems = @[@"HAIR",@"FACE & BODY",@"SPA",@"MAKEUP & BRIDAL",@"MEDISPA",@"TATOO & PIERCING",@"NAILS",@"TUTORIALS",@"OFFERS"];

    self.menuListView.delegate = self;
    self.menuListView.dataSource = self;
    [self.menuListView setBackgroundColor:[UIColor clearColor]];
    [self.HTHorizontalView addSubview:self.menuListView];
    
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
        
        arrayFilteredResults = [NSArray arrayWithArray:_services];
        [self.servicesTable reloadData];
    }
    else {
        
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [ServiceInvoker sharedInstance].city!=nil? [_cityName setTitle:[ServiceInvoker sharedInstance].city.cityName forState:UIControlStateNormal]:NSLog(@"");
        
        arrayFilteredResults = [NSArray new];
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
        
            NSPredicate *resultPredicate_gender;
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
            
            arrayFilteredResults = [weakArray filteredArrayUsingPredicate:multiplePredicate];
            
            [weakSelf.servicesTable reloadData];
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

    
    NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    parameters[@"cityId"] = idCity!=nil ? idCity : @"1";
    
    NSString *string_userId = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
    parameters[@"userId"] = string_userId!=nil ? string_userId : @"";
    
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


-(void)webServiceSortByStylist {
    
    NSString *string_userId = [NSString stringWithFormat:@"%@",[UtilityClass RetrieveDataFromUserDefault:@"userid"]] ;
    string_userId = string_userId!=nil ? string_userId : @"";

    NSLog(@"%@",string_userId);

    NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    idCity = idCity!=nil ? idCity : @"1";

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:idCity,@"cityId",[NSString stringWithFormat:@"%ld",(long)_serviceId],@"serviceId",string_userId,@"userId", nil];
    
    [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_GET_FAV_STYLIST spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
     {
         
         if (result == sirSuccess) {
             
             NSError *error = nil;
             NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
             
             if ([responseDict objectForKey:@"object"] != [NSNull null]) {
                 
                 array_Saloons = [responseDict objectForKey:@"object"];

                 _services = [[ServiceList initializeWithFavStylistsResponse:responseDict] mutableCopy];
                 
                 arrayFilteredResults = [NSArray arrayWithArray:_services];
                 
                 [self.servicesTable reloadData];
                 
             }else{
                 [UtilityClass showAlertwithTitle:@"" message:@"Object is Null"];
             }
             
             
         }else if (sirFailed){
             
         }
     }];
}


-(void)webServiceWithType:(MenuServiceType)serviceType{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
    parameters[@"cityId"] = idCity!=nil ? idCity : @"1";

    NSString *string_userId = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
    NSString *userId = string_userId!=nil ? string_userId : @"";
//    NSString *string_serviceId = [NSString stringWithFormat:@"%ld",(long)_serviceId];

    [parameters setObject:userId forKey:@"userId"];
//    [parameters setObject:string_serviceId forKey:@"serviceId"];

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
                [selfWeak showSaloonInfo];
                
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

    return cell;
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
        landingBriefViewController.service = arrayFilteredResults[indexPath.row];
        [self.navigationController pushViewController:landingBriefViewController animated:YES];

    }

}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (_menuListView.selectedButtonIndex) {

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

    ServiceList *service = arrayFilteredResults[[sender tag]];

    if ([service.extraParams isKindOfClass:[NSDictionary class]]) {

        NSDictionary *dictOffer = [service.extraParams objectForKey:@"offer"];

        __block ImageViewerViewController *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];

        CGRect rect = self.view.frame;
        rect.size.width = rect.size.width - 40;
        rect.size.height = rect.size.height - 60;
        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];
        if ([[dictOffer objectForKey:@"offerType"] isEqualToString:@"TEXT"]) {
            imageViewer.isTextDescription = YES;
            imageViewer.text_description = [dictOffer objectForKey:@"offerDesc"];
            imageViewer.images = [NSArray new];
        }else if ([[dictOffer objectForKey:@"offerType"] isEqualToString:@"IMAGE"]){
            imageViewer.isTextDescription = NO;
            imageViewer.images = [NSArray arrayWithObject:[dictOffer objectForKey:@"images"]]; // only one image url will be in offer
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

    ServiceList *service = arrayFilteredResults[[sender tag]];

    if ([service.extraParams isKindOfClass:[NSDictionary class]]) {

        NSDictionary *dictTutorial = [service.extraParams objectForKey:@"tutorials"];

        __block ImageViewerViewController *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];

        CGRect rect = self.view.frame;
        rect.size.width = rect.size.width - 40;
        rect.size.height = rect.size.height - 60;
        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];

        if ([[dictTutorial objectForKey:@"tutType"] isEqualToString:@"TEXT"]) {
            imageViewer.isTextDescription = YES;
            imageViewer.text_description = [dictTutorial objectForKey:@"tutDesc"];
            imageViewer.images = [NSArray new];
        }else if ([[dictTutorial objectForKey:@"tutType"] isEqualToString:@"IMAGE"]){
            imageViewer.isTextDescription = NO;
            imageViewer.images = [NSArray arrayWithObject:[dictTutorial objectForKey:@"images"]];
        }

        imageViewer.callbackCancel = ^(void) {
            [popoverController dismissPopoverAnimated:YES];
        };

    }else{
        [UtilityClass showAlertwithTitle:nil message:@"Currently No Tutorial available"];
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
        
        CGRect rect = self.view.frame;
        rect.size.width = rect.size.width - 40;
        rect.size.height = rect.size.height - 60;

        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];
        [popoverController presentPopoverAsDialogAnimated:YES completion:^{
            
        }];

        imageViewer.callbackCancel = ^(void) {
            [popoverController dismissPopoverAnimated:YES];
        };
    }
    
}

#pragma mark- Menulist Items Datasource & Delegate
- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return menuItems.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return menuItems[index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
  
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
        else {
            searchValue = [dict objectForKey:@"searchValue"];
            searchHelper = @"";
        }
        
        NSString *string_userId = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
        
        NSString *userId = string_userId!=nil ? string_userId : @"";
        
        NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:(idCity!=nil ? idCity : @"1"),@"cityId",searchKey,@"searchKey",searchValue,@"searchValue",searchHelper,@"searchHelper",userId,@"userId", nil];
        
        // Navigate to Landing Brief VC to display details
        SearchResultsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsController"];
        controller.requestParams = parameters;
        controller.serviceId = 1;
        [self.navigationController pushViewController:controller animated:YES];

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
    
    if (!isSearchReqQueued && searchText.length && !(searchText.length/3 == 0))
    {
        NSLog(@"Hit Web Service");
        //also check if already hit or not
        
        NSString *string_userId = [UtilityClass RetrieveDataFromUserDefault:@"userid"];
        string_userId = string_userId!=nil ? string_userId : @"";
        
        NSString *idCity = [ServiceInvoker sharedInstance].city.cityId;

        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:(idCity!=nil ? idCity : @"1"),@"cityId",searchText,@"searchString", nil];

        isSearchReqQueued = YES;
        
        [[ServiceInvoker sharedInstance] serviceInvokeWithParameters:parameters requestAPI:API_KEY_SEARCH spinningMessage:@"Fetching List..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result)
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
    
    return YES;
}


#pragma mark- Maps

//ye apple ka tha.........
//*************************************
-(IBAction)navigationButtonPressed:(NSIndexPath*)index{
    
    ServiceList *service = arrayFilteredResults[index.row];

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
