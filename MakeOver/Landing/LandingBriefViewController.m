//
//  LandingBriefViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "LandingBriefViewController.h"
#import "ServiceCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "UtilityClass.h"
#import "ServiceInvoker.h"
#import "AppDelegate.h"
#import "RatingViewController.h"
#import "FilterViewController.h"
#import "CollectionCell.h"
#import "Services.h"
#import "LandingBriefCell.h"
#import "UIImageView+WebCache.h"
#import "FavouriteStylistButton.h"
#import "MenuCollectionViewCell.h"

#import "ImageViewerViewController.h"
#import <FacebookSDK/FacebookSDK.h>


#import "Groups.h"

@interface LandingBriefViewController (){
    MenuViewController *menuController;
    FilterViewController *filterViewController;
}
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;


@end

@implementation LandingBriefViewController

#pragma mark - custom view setup method

- (void)setupBriefView
{
    self.saloonName.text = self.service.saloonName;

    [ServiceInvoker sharedInstance].city!=nil? [_cityName setTitle:[ServiceInvoker sharedInstance].city.cityName forState:UIControlStateNormal]:NSLog(@"");

    [self.distance setTitle:[NSString stringWithFormat:@"%@ KM",self.service.saloonDstfrmCurrLocation] forState:UIControlStateNormal];
    
    if (self.service.saloonServices.count) {
        [self.saloonDescription setText:[self.service.saloonServices componentsJoinedByString:@","]];
    }

    if ([self.service.gender isEqualToString:@"M"]) {
        self.genderImage.image = [UIImage imageNamed:@"ic_male"];
        self.genderImage2.hidden = YES;
        self.constraint_leading.constant =  3;
        [self.btn_info updateConstraints];
    }
    else if ([self.service.gender isEqualToString:@"F"]) {
        self.genderImage.image = [UIImage imageNamed:@"ic_female"];
        self.genderImage2.hidden = YES;
        self.constraint_leading.constant =  3;
        [self.btn_info updateConstraints];

    }
    else if ([self.service.gender isEqualToString:@"U"]) {
        self.genderImage.image = [UIImage imageNamed:@"ic_female"];
        self.genderImage2.image = [UIImage imageNamed:@"ic_male"];
        self.genderImage2.hidden = NO;
        self.constraint_leading.constant =  self.genderImage2.frame.size.width + 3;
        [self.btn_info updateConstraints];

    }

    self.textVw_saloonProductInfo.text = self.service.saloonProducts;

    if ([self.service.creditDebitCardSupport isEqualToString:@"Y"]) {
        self.lbl_creditDebitStatus.text = @"Credit/Debit Card Facility : YES";
    }else{
        self.lbl_creditDebitStatus.text = @"Credit/Debit Card Facility : NO";
    }


    [self.address setText:self.service.saloonAddress];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *startTime = [dateFormatter dateFromString:self.service.startTime];
    NSDate *endTime = [dateFormatter dateFromString:self.service.endTime];
    [dateFormatter setDateFormat:@"hh:mm a"];

    self.Time.text = [NSString stringWithFormat:@"%@ to %@",[dateFormatter stringFromDate:startTime],[dateFormatter stringFromDate:endTime]];

    [self.btnReviews setTitle:[NSString stringWithFormat:@"%@ reviews",self.service.sallonReviewCount] forState:UIControlStateNormal];

    [self.startRatingView setRating:[self.service.saloonRating doubleValue]];


    [self setupFavoriteAndRecentDetails];

    [_servicesTable reloadData];
}

- (void)setupFavoriteAndRecentDetails
{
    // Get fav saloons from saved records.

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *favsPath = [documentsDirectory stringByAppendingPathComponent:@"favSaloons.plist"]; //3

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:favsPath]) {
        self.favourite.selected = NO;
    }
    else {

        // Read records
        NSArray *arrayFavSaloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:favsPath];

        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [self.service.saloonId integerValue]];
        NSArray *arrayResult = [arrayFavSaloons filteredArrayUsingPredicate:resultPredicate];

        if ((arrayResult != nil) && (arrayResult.count))
            self.favourite.selected = YES;
        else
            self.favourite.selected = NO;
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
            NSMutableArray *saloons = [[NSMutableArray alloc] initWithObjects:self.service, nil];
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

        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [self.service.saloonId integerValue]];

        NSArray *arrayResult = [saloons filteredArrayUsingPredicate:resultPredicate];

        if ((arrayResult != nil) && (arrayResult.count)) {
            // Do nothing
        }
        else
        {
            if (saloons.count <10) {

                // write Record:
                //[saloons addObject:_services[indexPath.row]];
                [saloons addObject:self.service];
            }
            else {
                //[saloons replaceObjectAtIndex:saloons.count-1 withObject:_services[indexPath.row]];
                [saloons replaceObjectAtIndex:saloons.count-1 withObject:self.service];
            }

            if (![NSKeyedArchiver archiveRootObject:saloons toFile:savedRecordsPath]) {
                // Handle error
                NSLog(@"error in archieving");
            }
            else
                NSLog(@"Recently viewed object saved");
        }

    }
}

#pragma mark- UIViewController Methods

- (void)viewDidLoad {

    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];

    [self setupBriefView];

    [UtilityClass showSpinnerWithMessage:@"" onView:nil];
    [UtilityClass removeHudFromView:nil afterDelay:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- IBActions

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)filter:(id)sender{
    filterViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FilterViewController class])];
    [filterViewController.view setBackgroundColor:[UIColor clearColor]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:filterViewController.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:filterViewController.view];
}


/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
        {
            return _service.services.count*2;

        }
            break;
        case 1:
        {
            return _service.services.count*2;

        }
            break;
        case 2:
        {
            return 1;

        }
            break;
        default:
        {
            return _service.services.count*2;
        }
            break;
    }
}
*/



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch (_segmentControl.selectedSegmentIndex) {
            
        case 0:
        {
            return _service.menuImages.count;
            
        }
            break;
        case 1:
        {
            return _service.clubImages.count;
            
        }
            break;
        case 2:
        {
            NSInteger containerTableSection = [(StylistCollectionView*)collectionView tableSectionIndex];
            NSLog(@"containerTableSection : %li",(long)containerTableSection);
            NSInteger stylistCount = [[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] count];
            
            return stylistCount;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell;
    
    NSString *identifier = nil;

    if (collectionView == _servicesTable) {
        identifier = @"MenuCollectionCell";
        MenuCollectionViewCell *cell = (MenuCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        switch (_segmentControl.selectedSegmentIndex) {
                
            case 0:
            {
                id imageUrlString = [self.service.menuImages objectAtIndex:indexPath.row];
                
                if (imageUrlString != [NSNull null])
                    [cell.imageView_galleryOrMenu setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
                
            }
                break;
            case 1:
            {
                id imageUrlString = [self.service.clubImages objectAtIndex:indexPath.row];
                
                if (imageUrlString != [NSNull null])
                    [cell.imageView_galleryOrMenu setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
            }
                break;

            default:
            {
                return 0;
            }
                break;
        }
        
        return cell;
    }
    else
    {
        identifier = @"CollectionViewCellIdentifier";
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];

        NSInteger containerTableSection = [(StylistCollectionView*)collectionView tableSectionIndex];

        UIImageView *imageVw = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, 60, 60)];
        //imageVw.backgroundColor = [UIColor redColor];
        imageVw.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageVw];
        
        id imageUrlString = [[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"styListImgUrl"];
        
        if (imageUrlString != [NSNull null])
            [imageVw setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
        
        UILabel *lbl_stylistName = [[UILabel alloc]initWithFrame:CGRectMake(2, 60, 64, 20)];
        lbl_stylistName.backgroundColor = [UIColor clearColor];
        lbl_stylistName.textAlignment = NSTextAlignmentCenter;
        
        NSString *name = [[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"stylistName"];
        
        lbl_stylistName.text = name;
        lbl_stylistName.font = [UIFont boldSystemFontOfSize:11];
        lbl_stylistName.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:lbl_stylistName];
        [cell.contentView bringSubviewToFront:lbl_stylistName];
        
        FavouriteStylistButton *btn = [FavouriteStylistButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 76, 20, 20);
        btn.tableSectionIndex = containerTableSection;
        btn.collectionViewIndex = collectionView.tag;
        btn.collectionViewCellIndex = indexPath.row;
        
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(action_addFavourite:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        [cell.contentView bringSubviewToFront:btn];
        
        id favObj = [[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"faborateFlag"];
        
        BOOL isFavourite = NO;
        
        if (favObj != [NSNull null])
            isFavourite = [favObj boolValue];
        else
            isFavourite = NO;

        if (isFavourite) {
            [btn setSelected:YES];
            [btn setImage:nil forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"ic_favoritefill"] forState:UIControlStateSelected];
        }
        else {
            [btn setSelected:NO];
            [btn setImage:nil forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
        }
        
        UILabel *lbl_review = [[UILabel alloc]initWithFrame:CGRectMake(24, 76, 60, 16)];
        lbl_review.backgroundColor = [UIColor clearColor];
        
        NSString *fabCount = [[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"stylistFabCount"];

        lbl_review.text = [NSString stringWithFormat:@"%@ favorites",fabCount];
        lbl_review.font = [UIFont systemFontOfSize:10];
        //lbl_review.textAlignment = NSTextAlignmentCenter;
        //lbl_review.backgroundColor = [UIColor blueColor];
        lbl_review.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:lbl_review];
        [cell.contentView bringSubviewToFront:lbl_review];

 //       NSArray *collectionViewArray = self.colorArray[collectionView.tag];
        cell.backgroundColor = [UIColor clearColor];//collectionViewArray[indexPath.item];
        
        return cell;

    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_segmentControl.selectedSegmentIndex) {
            
        case 0:
            [self imageViewerPresent:_service.menuImages atIndex:indexPath];
            break;
        case 1:
            [self imageViewerPresent:_service.clubImages atIndex:indexPath];// Dnt know what to show
            break;
        
        default:
        {
            // do nothing
        }
            break;
    }
}

-(void)imageViewerPresent:(NSArray*)images atIndex:(NSIndexPath*)index{
    
    if (images.count) {
        __block ImageViewerViewController *imageViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ImageViewerViewController class])];
       
        imageViewer.startImageIndexPath = index;
        imageViewer.isShowingGallery = YES;
        
        imageViewer.images = images;
        
        CGRect rect = self.view.frame;
        rect.size.width = rect.size.width- 40;
        rect.size.height = rect.size.height -60;
        
        [popoverController setPopoverContentSize:rect.size];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:imageViewer];
        [popoverController presentPopoverAsDialogAnimated:YES completion:^{
            
        }];

        imageViewer.callbackCancel = ^(void) {
            [popoverController dismissPopoverAnimated:YES];
        };
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize returnSize;
    
    if (collectionView == _servicesTable) {
        returnSize = CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.width/3);
    }else{
        returnSize = CGSizeMake(80, 110);
    }
    
    return returnSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    CGFloat returnSpacing;
    
    if (collectionView == _servicesTable) {
        returnSpacing = 0;
    }else{
        returnSpacing = 0;
    }
    
    return returnSpacing;
    
}

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        NSString *titleText = [NSString stringWithFormat:@"%@ (Senior)",[(Services*)_service.services[indexPath.row] serviceName]];
        [(UILabel*)[reusableview viewWithTag:10]setText:@"FACE AND BODY (SENIOR)"];
        return reusableview;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_segmentControl.selectedSegmentIndex <2) {
        CollectionCell *cell = (CollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        //    [menuController setImages:cell.imageView.image];
        [self.navigationController pushViewController:menuController animated:YES];
        //    [menuController.imageCollection selectItemAtIndexPath:indexpath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }

    
}
*/

-(void)action_addFavourite:(id)sender{
    
    FavouriteStylistButton *button = (FavouriteStylistButton*)sender;
    
    //[[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"faborateFlag"];
    
    NSString *favObj = [[[[[[self.service.services objectAtIndex:button.tableSectionIndex] groups] objectAtIndex:button.collectionViewIndex] stylistresp] objectAtIndex:button.collectionViewCellIndex] objectForKey:@"faborateFlag"];
    
    
    if ((favObj != [NSNull null]) && ([favObj isEqualToString:@"Y"])) {
        favObj = @"N";
    }
    else
    {
        favObj = @"Y";
    }
    
    NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];
    string_userId = string_userId!=nil ? string_userId : @"";

    
    if ((string_userId != nil) && string_userId.length) {
        
        NSString *string_stylistId = [[[[[[[self.service.services objectAtIndex:button.tableSectionIndex] groups] objectAtIndex:button.collectionViewIndex] stylistresp] objectAtIndex:button.collectionViewCellIndex] objectForKey:@"stylishId"] stringValue];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:string_userId,@"userId",string_stylistId,@"stylishId",favObj,@"fabFlag", nil];
        [self serviceRequestWithParameters:dict andSender:sender];
    }
    else {
        [UtilityClass showAlertwithTitle:@"Login required!" message:@"You need to be logged in to perform this action."];
    }
    
}

-(void)serviceRequestWithParameters:(NSDictionary*)parameter andSender:(id)sender{
    
    [[[ServiceInvoker alloc]init]serviceInvokeWithParameters:parameter requestAPI:API_ADD_FAVOURITE spinningMessage:@"Loading..." completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {
        
        FavouriteStylistButton *button = (FavouriteStylistButton*)sender;

        if (result == sirSuccess)
        {
            NSError *error = nil;
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
 
            NSString *favObj = [[[[[[self.service.services objectAtIndex:button.tableSectionIndex] groups] objectAtIndex:button.collectionViewIndex] stylistresp] objectAtIndex:button.collectionViewCellIndex] objectForKey:@"faborateFlag"];
            
            NSMutableDictionary *stylistDict = [[[[[[self.service.services objectAtIndex:button.tableSectionIndex] groups] objectAtIndex:button.collectionViewIndex] stylistresp] objectAtIndex:button.collectionViewCellIndex] mutableCopy];
            [stylistDict setObject:[responseDict objectForKey:@"object"] forKey:@"stylistFabCount"];

            
            // if successful then update button image accordingly
            if ((favObj != [NSNull null]) && ([favObj isEqualToString:@"Y"])) {
                [button setSelected:NO];
                [button setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
                
                [stylistDict setObject:@"N" forKey:@"faborateFlag"];
            }
            else
            {
                [button setSelected:YES];
                [button setImage:[UIImage imageNamed:@"ic_favoritefill"] forState:UIControlStateSelected];
                
                [stylistDict setObject:@"Y" forKey:@"faborateFlag"];
            }
            
            
            [[[[[self.service.services objectAtIndex:button.tableSectionIndex] groups] objectAtIndex:button.collectionViewIndex] stylistresp] replaceObjectAtIndex:button.collectionViewCellIndex withObject:stylistDict];
            
            [_tbl_stylist reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:button.collectionViewIndex inSection:button.tableSectionIndex]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{
            // if unsuccessful then update button image accordingly
            [button setSelected:NO];
            [button setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)selectCity:(id)sender{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appdelegate selectCityActionWithController:self popverFroomRect:_cityName.frame CompletionHandler:^(NSString *cityName, NSIndexPath *indexPath) {
        [_cityName setTitle:cityName forState:UIControlStateNormal];
    }];
}

-(IBAction)reviewPresent:(id)sender{
    
    __block ReviewViewController *review = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReviewViewController class])];
    [review setModalPresentationStyle:UIModalPresentationFormSheet];
    [review setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    CGRect rect = self.view.frame;
    rect.size.width = rect.size.width -20;
    rect.size.height = rect.size.height -20;
    rect.origin.x = rect.origin.x -20;
    rect.origin.y = rect.origin.y -20;
    
    review.service = _service;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:review];
    [popoverController presentPopoverAsDialogAnimated:YES completion:^{
        
    }];
    
}


-(IBAction)ratingOpen:(id)sender{
    
    NSString *string_userId = [[UtilityClass RetrieveDataFromUserDefault:@"userid"] stringValue];
    
    if ((string_userId != nil) && string_userId.length) {
        
        __block RatingViewController *rating = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RatingViewController class])];
        popoverController = [[WYPopoverController alloc] initWithContentViewController:rating];
        
        [rating ratingCompletion:^(NSString* review , double rating ,BOOL isCancelled) {
            
            if (!isCancelled) {
                
                NSDictionary *prams = @{
                                        @"saloonId" : _service.saloonId,
                                        @"rating" : @(rating),
                                        @"review" : review,
                                        @"userId" :string_userId
                                        };
                [[[ServiceInvoker alloc]init] serviceInvokeWithParameters:prams requestAPI:API_RATE_SALOON spinningMessage:nil completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {
                    
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
                    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:nil message:(response[@"error"])[@"errorMessage"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }];
            }
            
            [popoverController dismissPopoverAnimated:YES];
        }];
        [popoverController setPopoverContentSize:CGSizeMake(300, 300)];
        [popoverController presentPopoverAsDialogAnimated:YES completion:^{
            [rating.reviewDescription becomeFirstResponder];
            
        }];

    }
    else {
        [UtilityClass showAlertwithTitle:@"Login required!" message:@"You need to be logged in to perform this action."];
    }
    
}


- (IBAction)segmentSelection:(UISegmentedControl *)sender {
    
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
        {
            self.view_tableContainer.hidden = YES;
            _servicesTable.hidden = NO;
            [_servicesTable reloadData];
            self.view_otherInfo.hidden = YES;
        }
            break;
        case 1:
        {
            self.view_tableContainer.hidden = YES;
            _servicesTable.hidden = NO;
            [_servicesTable reloadData];
            self.view_otherInfo.hidden = YES;
        }
            break;
        case 2:
        {
            self.view_tableContainer.hidden = NO;
            _servicesTable.hidden = YES;
            [_tbl_stylist reloadData];
            self.view_otherInfo.hidden = YES;
        }
            break;
        case 3:
        {
            self.view_tableContainer.hidden = YES;
            _servicesTable.hidden = YES;
            self.view_otherInfo.hidden = NO;
        }
            break;
        default:
        {
            
        }
            break;
    }
}

- (IBAction)favButtonDidTap:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *favsPath = [documentsDirectory stringByAppendingPathComponent:@"favSaloons.plist"];
    
    // Read & Update records
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (!self.favourite.isSelected) // not present in favourite
    {
        
        if (![fileManager fileExistsAtPath:favsPath]) //if file doesn't exist at path then create & add fav
        {
            
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"favSaloons" ofType:@"plist"]; //5
            
            NSError *error;
            [fileManager copyItemAtPath:bundle toPath:favsPath error:&error]; //6
            
            if (!error) {
                
                NSLog(@"favSaloons.plist created at Documents directory.");
                
                NSMutableArray *favSaloons = [[NSMutableArray alloc] initWithObjects:self.service, nil];
                if (![NSKeyedArchiver archiveRootObject:favSaloons toFile:favsPath]) {
                    // Handle error
                    NSLog(@"error in archieving");
                }
                else {
                    self.favourite.selected = YES;
                    NSLog(@"favourite saloon saved");
                }
            }
        }
        else { // file exists at path so add favourite
            
            NSMutableArray *favSaloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:favsPath];
            [favSaloons addObject:self.service];
            self.favourite.selected = YES;

            if (![NSKeyedArchiver archiveRootObject:favSaloons toFile:favsPath]) {
                // Handle error
                NSLog(@"error in archieving");
            }
            else
                NSLog(@"fav saloon object saved");
        }
    }
    else { // remove from favourite list
        
        NSMutableArray *favSaloons = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:favsPath];
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.saloonId == %i", [[self.service saloonId] integerValue]];
        
        NSArray *arrayResult = [favSaloons filteredArrayUsingPredicate:resultPredicate];
        
        if ((arrayResult != nil) && (arrayResult.count)) {
            [favSaloons removeObject:[arrayResult objectAtIndex:0]];
        }
        
        if (![NSKeyedArchiver archiveRootObject:favSaloons toFile:favsPath]) {
            // Handle error
            NSLog(@"error in archieving");
        }
        else {
            NSLog(@"fav saloon object removed");
            self.favourite.selected = NO;
        }
    }
    
}

- (IBAction)callButtonDidTap:(id)sender {
    
    if (_service.contacts.count) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select number to call" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        for (NSString *number in _service.contacts) {
                [actionSheet addButtonWithTitle:number];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        
        [actionSheet setCancelButtonIndex:_service.contacts.count];
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    else {
        [UtilityClass showAlertwithTitle:@"" message:@"Contact number not available for this saloon."];
    }

}

- (IBAction)showInfo:(id)sender {
    
    [UtilityClass showAlertwithTitle:nil message:self.service.saloonInfo];

}

- (IBAction)checkinButtonDidTap:(id)sender {
    
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (!buttonIndex == _service.contacts.count) {
        NSString *phoneNumber = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}


-(IBAction)menuOpen:(id)sender{
    menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//    [menuController setImages:cell.collectionImages];
    [self.navigationController pushViewController:menuController animated:YES];
//    [menuController.imageCollection selectItemAtIndexPath:indexpath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.service.services.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segmentControl.selectedSegmentIndex == 2) {
        return [[[self.service.services objectAtIndex:section] groups] count];
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    LandingBriefCell *cell = [[LandingBriefCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.lblStylistCategory.text = [[[[self.service.services objectAtIndex:indexPath.section] groups] objectAtIndex:indexPath.row] positionName];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(LandingBriefCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_segmentControl.selectedSegmentIndex) {
        case 2:
        {
            [cell setCollectionViewDataSourceDelegate:self index:indexPath];
            NSInteger index = cell.collectionView.tag;
            
            CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
            [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
        }
            break;
        default:
        {

        }
            break;
    }
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (_segmentControl.selectedSegmentIndex) {
        case 2:
        {
            return 20;
        }
            break;
        default:
        {
            return 1;
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0,tableView.frame.size.width, 20)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    label.text = [[self.service.services objectAtIndex:section] serviceName];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [viewHeader addSubview:label];
    
    return viewHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_segmentControl.selectedSegmentIndex) {
        case 2:
        {
            return 110;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (_segmentControl.selectedSegmentIndex) {
        case 2:
        {
            if (![scrollView isKindOfClass:[UICollectionView class]]) return;
            
            CGFloat horizontalOffset = scrollView.contentOffset.x;
            
            UICollectionView *collectionView = (UICollectionView *)scrollView;
            NSInteger index = collectionView.tag;
            self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
        }
            break;
        default:
        {
            
        }
            break;
    }
}



#pragma mark- Maps

//ye apple ka tha.........
//*************************************
-(IBAction)navigationButtonPressed:(id)sender
{
    
    if (_service.saloonLat.length && _service.saloonLong.length) {
        
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]])
        {
            NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?daddr=%@,%@&zoom=14&directionsmode=driving",_service.saloonLat,_service.saloonLong];
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:urlString]];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@",_service.saloonLat,_service.saloonLong];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }
    }
    else {
        [UtilityClass showAlertwithTitle:nil message:@"Directions unavailable for this location."];
    }
    
        // Check for iOS 6
        /*Class mapItemClass = [MKMapItem class];
         if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
         {
         // Create an MKMapItem to pass to the Maps app
         CLLocationCoordinate2D coordinate =
         CLLocationCoordinate2DMake(16.775, -3.009);
         MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
         addressDictionary:nil];
         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
         [mapItem setName:@"My Place"];
         
         // Set the directions mode to "Walking"
         // Can use MKLaunchOptionsDirectionsModeDriving instead
         NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
         // Get the "Current User Location" MKMapItem
         MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
         // Pass the current location and destination map items to the Maps app
         // Set the direction mode in the launchOptions dictionary
         [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
         launchOptions:launchOptions];
         }
         */
}


@end
