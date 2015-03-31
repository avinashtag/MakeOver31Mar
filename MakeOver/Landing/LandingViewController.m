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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}





@end
