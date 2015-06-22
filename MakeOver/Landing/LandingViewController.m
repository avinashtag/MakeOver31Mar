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
#import "SearchResultsController.h"

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

    array_SearchResults = [NSMutableArray new];
    _ddList = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
    _ddList._delegate = self;
    [_ddList.view setFrame:CGRectMake(0,88.0, self.view.frame.size.width, 0)];
    [self.view addSubview:_ddList.view];
    
    [self performSelector:@selector(setDefaultCity) withObject:nil afterDelay:1.0];
}

- (void)viewDidLayoutSubviews {
    
    _cityName.imageEdgeInsets = UIEdgeInsetsMake(2, _cityName.frame.size.width-6, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefaultCity {
    
    City *stringCityName = [ServiceInvoker sharedInstance].city;
    
    if (stringCityName)
        [_cityName setTitle:stringCityName.cityName forState:UIControlStateNormal];
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
            [cell.serviceName setText:@"MEDISPA"];
            break;

        case 5:
            [cell.serviceImage setImage:[UIImage imageNamed:@"06-tattoos&piercing"]];
            [cell.serviceName setText:@"TATTOO & PIERCING"];
            break;

        case 6:
            [cell.serviceImage setImage:[UIImage imageNamed:@"07-nailservices"]];
            [cell.serviceName setText:@"NAILS"];
            break;

        case 7:
            [cell.serviceImage setImage:[UIImage imageNamed:@"08-hair&makeup"]];
            [cell.serviceName setText:@"TUTORIALS"];
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
    landingservice.serviceId = indexPath.row +1;
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
        /*
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
         */
    }
    else {
        
    }
}

-(void)didSelectRowWithObject:(id)object{
    
    _searchBar.text = nil;  // objServiceList.saloonName;
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
        controller.searcheSaloonServices = arrayServices;
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




@end
