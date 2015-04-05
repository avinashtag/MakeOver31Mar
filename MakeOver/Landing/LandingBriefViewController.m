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

#import "Groups.h"

@interface LandingBriefViewController (){
    MenuViewController *menuController;
    FilterViewController *filterViewController;
}
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;


@end

@implementation LandingBriefViewController

#pragma mark- UIViewController Methods

-(void)loadView
{
    [super loadView];
    
    const NSInteger numberOfTableViewRows = 20;
    const NSInteger numberOfCollectionViewCells = 15;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
        
        for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
        {
            
            CGFloat red = arc4random() % 255;
            CGFloat green = arc4random() % 255;
            CGFloat blue = arc4random() % 255;
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
            
            [colorArray addObject:color];
        }
        
        [mutableArray addObject:colorArray];
    }
    
    self.colorArray = [NSArray arrayWithArray:mutableArray];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}

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

/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
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
            return 30;
            
        }
            break;
        case 1:
        {
            return 14;
            
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
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }
    else
    {
        identifier = @"CollectionViewCellIdentifier";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];

        NSInteger containerTableSection = [(StylistCollectionView*)collectionView tableSectionIndex];

        UIImageView *imageVw = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
        imageVw.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:imageVw];
        
        NSString *imageUrlString = [[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"styListImgUrl"];
        [imageVw setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:nil];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(9, 90, 32, 32);
        btn.backgroundColor = [UIColor greenColor];
        [cell.contentView addSubview:btn];
        id favObj = [[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"faborateFlag"];
        BOOL isFavourite;
        if (favObj != [NSNull null])
            isFavourite = [favObj boolValue];
        else
            isFavourite = NO;

        if (isFavourite) {
            [btn setSelected:YES];
            [btn setImage:[UIImage imageNamed:@"ic_favoritefill"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
        }
        
            
        
        UILabel *lbl_review = [[UILabel alloc]initWithFrame:CGRectMake(40, 90, 50, 20)];
        lbl_review.backgroundColor = [UIColor clearColor];
        
        NSString *fabCount = [[[[[[self.service.services objectAtIndex:containerTableSection] groups] objectAtIndex:collectionView.tag] stylistresp] objectAtIndex:indexPath.row] objectForKey:@"stylistFabCount"];
        
        lbl_review.text = [NSString stringWithFormat:@"%@ reviews",fabCount];
        lbl_review.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lbl_review];
        
 //       NSArray *collectionViewArray = self.colorArray[collectionView.tag];
        cell.backgroundColor = [UIColor clearColor];//collectionViewArray[indexPath.item];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize returnSize;
    
    if (collectionView == _servicesTable) {
        returnSize = CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.width/3);
    }else{
        returnSize = CGSizeMake(80, 80);
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
    
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
        {
            self.view_tableContainer.hidden = YES;
            _servicesTable.hidden = NO;
            [_servicesTable reloadData];
        }
            break;
        case 1:
        {
            self.view_tableContainer.hidden = YES;
            _servicesTable.hidden = NO;
            [_servicesTable reloadData];
        }
            break;
        case 2:
        {
            NSLog(@"%@",[[[[self.service.services objectAtIndex:0] groups] objectAtIndex:0] positionName]);
            
            
            self.view_tableContainer.hidden = NO;
            _servicesTable.hidden = YES;
            [_tbl_stylist reloadData];
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
    
    LandingBriefCell *cell = (LandingBriefCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[LandingBriefCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.lblStylistCategory.text = [[[[self.service.services objectAtIndex:indexPath.section] groups] objectAtIndex:indexPath.row] positionName];
    
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
            return 100;
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


@end
