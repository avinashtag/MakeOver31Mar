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


@interface LandingServicesViewController (){
    WYPopoverController *popoverController;
    FilterViewController *filterViewController;
}

@end

@implementation LandingServicesViewController

typedef enum {
    sMAKEUP= 0,
    sFACEBODY,
    sOFFERS,
    sTUTORIAL,
    sHAIR,
}MenuServiceType;

static NSArray *menuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuListView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    menuItems = @[@"MAKEUP",@"FACE & BODY",@"OFFERS",@"TUTORIAL",@"HAIR"];
    self.menuListView.delegate = self;
    self.menuListView.dataSource = self;[self.menuListView setBackgroundColor:[UIColor clearColor]];
    [self.HTHorizontalView addSubview:self.menuListView];
    
    [self serviceLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [ServiceInvoker sharedInstance].city!=nil? [_cityName setTitle:[ServiceInvoker sharedInstance].city.cityName forState:UIControlStateNormal]:NSLog(@"");
    
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)filter:(id)sender{
    filterViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FilterViewController class])];
    [filterViewController.view setBackgroundColor:[UIColor clearColor]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:filterViewController.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:filterViewController.view];
}

-(void)serviceLoad{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"serviceId"] = @(_serviceId);
    CLLocationCoordinate2D location = [ServiceInvoker sharedInstance].coordinate;
    parameters[@"curr_lat"] =[NSString stringWithFormat:@"%f",location.latitude];//:@"28.089";
    parameters[@"curr_Long"] =[NSString stringWithFormat:@"%f",location.longitude];// @"77.986";
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
            [self.servicesTable reloadData];
        }
    }];
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
    
    
    NSString *identifier =[self reuseIdentifier];
    ServiceCell *cell = (ServiceCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ServiceList *service = _services[indexPath.row];
    cell.name.text = service.saloonName;
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
                [selfWeak imageViewerPresent:[service.styleList valueForKeyPath:@"imageUrl"]];
                break;
            case tPhoto:
                [selfWeak imageViewerPresent:[service.styleList valueForKeyPath:@"imageUrl"]];
                break;
            case tInfo:
                [selfWeak showSaloonInfo];
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
            landingBriefViewController.service = _services[indexPath.row];
            [landingBriefViewController.servicesTable reloadData];
            [UtilityClass removeHudFromView:nil afterDelay:0];
            
            
            // add this saloon in recently viewed records.
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
            NSString *documentsDirectory = [paths objectAtIndex:0]; //2
            NSString *savedRecordsPath = [documentsDirectory stringByAppendingPathComponent:@"recentlyViewed.plist"]; //3
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:savedRecordsPath]) //if file doesn't exist at path then create
            {
                NSString *bundle = [[NSBundle mainBundle] pathForResource:@"recentlyViewed" ofType:@"plist"]; //5
                
                NSError *error;
                [fileManager copyItemAtPath:bundle toPath:savedRecordsPath error:&error]; //6
                
                if (!error) {
                    
                    NSLog(@"recentlyViewed.plist created at Documents directory.");
                    
                    NSMutableArray *saloons = [[NSMutableArray alloc] initWithObjects:_services[indexPath.row], nil];
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
                
                if ([saloons indexOfObject:_services[indexPath.row]] != NSNotFound) {
                    // Do nothing
                }
                else {
                    
                    if (saloons.count <10) {
                        
                        // write Record:
                        [saloons addObject:_services[indexPath.row]];
                    }
                    else {
                        [saloons replaceObjectAtIndex:saloons.count-1 withObject:_services[indexPath.row]];
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
        case sMAKEUP:
            break;
            
        case sFACEBODY:
            
            break;
            
        case sHAIR:
            
            break;
            
        case sOFFERS:
            
            break;
            
        case sTUTORIAL:
            
            break;
  
        default:
            break;
    }
    [_servicesTable reloadData];
}

-(NSString*)reuseIdentifier{
    
    switch (_menuListView.selectedButtonIndex) {
        case sMAKEUP:
            return  @"ServiceCellIdentifier";

            break;
            
        case sFACEBODY:
            return  @"ServiceCellIdentifier";

            break;
            
        case sHAIR:
            return  @"ServiceCellIdentifier";

            break;
            
        case sOFFERS:
            return  @"OfferCell";

            break;
            
        case sTUTORIAL:
            return  @"TutorialCell";

            break;
            
        default:
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
