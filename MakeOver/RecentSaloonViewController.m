//
//  RecentSaloonViewController.m
//  MakeOver
//
//  Created by Pankaj Yadav on 29/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "RecentSaloonViewController.h"
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
#import "ServiceCell.h"
#import "LandingServicesViewController.h"


@interface RecentSaloonViewController (){
    WYPopoverController *popoverController;
    NSArray *array_favSaloons;
}

@end

@implementation RecentSaloonViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _services = [[NSMutableArray alloc]init];
    [self loadRecentSaloonList];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    if (_services.count) {
        [_services removeAllObjects];
        [self loadRecentSaloonList];
    }
}

- (void)loadRecentSaloonList {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *savedRecordsPath = [documentsDirectory stringByAppendingPathComponent:@"recentlyViewed.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:savedRecordsPath]) //if file doesn't exist at path then create
    {
        NSLog(@"No records for recently viewed saloons.");
    }
    else {
        
        // Read & Update records
        _services = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:savedRecordsPath];
        [_serviceTable reloadData];
    }
    
    // Get fav saloons from saved records.
    
    NSString *favsPath = [documentsDirectory stringByAppendingPathComponent:@"favSaloons.plist"]; //3
    
    if (![fileManager fileExistsAtPath:favsPath]) //if file doesn't exist at path then create
    {
        // Do nothing
        array_favSaloons = [NSMutableArray new];
    }
    else {
        
        // Read records
        array_favSaloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:favsPath];
    }
    
    [_serviceTable reloadData];
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
    return _services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *identifier =@"ServiceCellIdentifier";
    ServiceCell *cell = (ServiceCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ServiceList *service = _services[indexPath.row];
    cell.name.text = service.saloonName;
    [cell.distance setTitle:[NSString stringWithFormat:@"%@ KM",service.saloonDstfrmCurrLocation] forState:UIControlStateNormal];
    if (service.saloonServices.count) {
        [cell.descriptionService setText:[service.saloonServices componentsJoinedByString:@","]];
    }


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


    //[cell.address setText:service.saloonAddress];
    [cell.address setText:service.saloonMainArea];

    [cell.reviewCounts setTitle:[NSString stringWithFormat:@"%@ reviews",service.sallonReviewCount] forState:UIControlStateNormal];
    __weak RecentSaloonViewController *selfWeak = self;
    [cell reviewWithCompletion:^(UIButton *sender, ServiceCollectionType serviceType){
        switch (serviceType) {
            case tReview:
                [selfWeak reviewPresent:indexPath];
                break;
            case tMenu:
                [selfWeak imageViewerPresent:[service.styleList valueForKeyPath:@"imageUrl"]];
                break;
            case tPhoto:
                [selfWeak imageViewerPresent:[service.styleList valueForKeyPath:@"imageUrl"]];
                break;
            case tInfo:
                [selfWeak showSaloonInfo];
                
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
    //    cell.startRatingView = [cell.startRatingView initWithFrame:cell.startRatingView.frame andRating:[service.saloonRating intValue] withLabel:NO animated:YES withCompletion:^(NSInteger rating) {
    
    //        [self ratingOpen];
    //    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // Navigate to Landing Brief VC to display details
    LandingBriefViewController *landingBriefViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingBriefViewController"];
    landingBriefViewController.service = _services[indexPath.row];
    [self.navigationController pushViewController:landingBriefViewController animated:YES];
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 172.0f;
}

-(void)reviewPresent:(NSIndexPath*)index{
    
    __block ReviewViewController *review = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReviewViewController class])];
    review.service = _services[index.row];
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


-(void)imageViewerPresent:(NSArray*)images{
    if (images.count) {
        __block ImageViewerViewController *review = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];
        review.images = images;
        
        CGRect rect = self.view.frame;
        rect.size.width = rect.size.width- 40;
        rect.size.height = rect.size.height -60;
        
        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:review];
        [popoverController presentPopoverAsDialogAnimated:YES completion:^{
            
        }];

        review.callbackCancel = ^(void) {
            [popoverController dismissPopoverAnimated:YES];
        };
    }
    
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
-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Maps

//ye apple ka tha.........
//*************************************
-(IBAction)navigationButtonPressed:(NSIndexPath*)index{
    
    ServiceList *service = array_favSaloons[index.row];
    
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


@end
