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

@interface LandingBriefViewController (){
    MenuViewController *menuController;
    FilterViewController *filterViewController;
}

@end

@implementation LandingBriefViewController

#pragma mark- UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [ServiceInvoker sharedInstance].city!=nil? [_cityName setTitle:[ServiceInvoker sharedInstance].city.cityName forState:UIControlStateNormal]:NSLog(@"");
//    [_servicesTable registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    // [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-big.png"]] ];
    
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _service.services.count*2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_service.services[section] groups].count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = nil;
    switch (_segmentControl.selectedSegmentIndex) {
        case 2:
            identifier = @"stylistCollectionCell";
            break;
        default:
            identifier = @"MenuCollectionCell";
            break;
    }
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    switch (_segmentControl.selectedSegmentIndex) {
        case 2:
            [cell doFavStylistCompletion:^(id sender) {
                //TODO:: Pankaj Favourite Code
                
            }];
            break;
        default:
            break;
    }

    (_segmentControl.selectedSegmentIndex) == 2? [cell.imageView.layer setCornerRadius:5.0]:NSLog(@"asd");
    [cell.favourite setSelected:YES];
//    [cell.imageView setImage:[UIImage imageNamed:@""]];
//    [cell.review setText:@""];
    
    
    return cell;
}

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
    
    __block RatingViewController *rating = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RatingViewController class])];
    popoverController = [[WYPopoverController alloc] initWithContentViewController:rating];
    [rating ratingCompletion:^(NSString* review , double rating ,BOOL isCancelled) {
        
        if (!isCancelled) {
            
            NSDictionary *prams = @{
                                    @"stylishId" : _service.saloonId,
                                    @"rating" : @(rating),
                                    @"review" : review,
                                    @"userId" : @"3"
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


- (IBAction)segmentSelection:(UISegmentedControl *)sender {
    
    [_servicesTable reloadData];
}


-(IBAction)menuOpen:(id)sender{
    menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//    [menuController setImages:cell.collectionImages];
    [self.navigationController pushViewController:menuController animated:YES];
//    [menuController.imageCollection selectItemAtIndexPath:indexpath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
}
@end
