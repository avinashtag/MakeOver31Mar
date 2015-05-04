//
//  LandingViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "LandingViewController.h"
#import "LandingCell.h"
#import "WYPopoverController.h"
#import "CustomSelection.h"
#import "LandingServicesViewController.h"
#import "ServiceInvoker.h"
#import "City.h"
#import "ServiceList.h"
#import "LandingBriefViewController.h"

@interface LandingViewController () <ServiceInvokerDelegate>{
    
    WYPopoverController *popoverController;
//    LandingServicesViewController *landingservice;
}

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [ServiceInvoker sharedInstance];
    
    [_servicesTable reloadData];
    [ServiceInvoker sharedInstance].city!=nil? [_cityName setTitle:[ServiceInvoker sharedInstance].city.cityName forState:UIControlStateNormal]:NSLog(@"");

    array_SearchResults = [NSMutableArray new];
    _ddList = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
    _ddList._delegate = self;
    [_ddList.view setFrame:CGRectMake(0,88.0, self.view.frame.size.width, 0)];
    [self.view addSubview:_ddList.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier = @"LandingIdentifier";
    LandingCell *cell = (LandingCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.row)
    {
        case 0:
            [cell.serviceImage setImage:[UIImage imageNamed:@"01_hairservices"]];
            [cell.serviceName setText:@"HAIR SERVICES"];
            break;
        case 1:
            [cell.serviceImage setImage:[UIImage imageNamed:@"02-face&body"]];
            [cell.serviceName setText:@"FACE AND BODY"];
            break;
        case 2:
            [cell.serviceImage setImage:[UIImage imageNamed:@"03_spa"]];
            [cell.serviceName setText:@"SPA"];
            break;
        case 3:
            [cell.serviceImage setImage:[UIImage imageNamed:@"04-makeup&bridal"]];
            [cell.serviceName setText:@"MAKEUP & BRIDAL"];
            break;

        case 4:
            [cell.serviceImage setImage:[UIImage imageNamed:@"05-medispa"]];
            [cell.serviceName setText:@"MEDI-SPA"];
            break;

        case 5:
            [cell.serviceImage setImage:[UIImage imageNamed:@"06-tattoos&piercing"]];
            [cell.serviceName setText:@"TATTOOS & PIERCING"];
            break;

        case 6:
            [cell.serviceImage setImage:[UIImage imageNamed:@"07-nailservices"]];
            [cell.serviceName setText:@"NAIL SERVICES"];
            break;

        case 7:
            [cell.serviceImage setImage:[UIImage imageNamed:@"08-hair&makeup"]];
            [cell.serviceName setText:@"HAIR & MAKEUP"];
            break;

        case 8:
            [cell.serviceImage setImage:[UIImage imageNamed:@"09-offers"]];
            [cell.serviceName setText:@"OFFERS"];
            break;


        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LandingServicesViewController *landingservice = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingServicesViewController"];
    landingservice.serviceId = indexPath.row;
    [self.navigationController pushViewController:landingservice animated:YES];
}


- (IBAction)selectCity:(id)sender{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [appdelegate selectCityActionWithController:self popverFroomRect:_cityName.frame CompletionHandler:^(NSString *cityName, NSIndexPath *indexPath) {
        [_cityName setTitle:cityName forState:UIControlStateNormal];
    }];

}




#pragma mark -
#pragma mark DropDownListPassValueDelegate protocol

- (void)setDDListHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0 : 180;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [_ddList.view setFrame:CGRectMake(0,88.0, self.view.frame.size.width, height)];
    [UIView commitAnimations];
}


-(void)firstRowSelectedWithValue:(id)value {
    if (value) {
        [self searchBarSearchButtonClicked:searchBar];
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
    
    searchBar.text = nil;// objServiceList.saloonName;
    [self searchBarSearchButtonClicked:searchBar];
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
