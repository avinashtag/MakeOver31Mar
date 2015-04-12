//
//  FilterViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 22/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "FilterViewController.h"
#import "NMRangeSlider.h"
#import "FavouriteStylistController.h"

@implementation FilterCell





@end
@interface FilterViewController (){
    NSArray *menuItems;
    NSArray *cellReload;
}

@end

NSString *const ksortByFavouriteStylist = @"sortByFavouriteStylist";
NSString *const ksortByDistance = @"sortByDistance";
NSString *const ksortByRating = @"sortByRating";
NSString *const kfilterBySex = @"filterBySex";
NSString *const kfilterByTime = @"filterByTime";
NSString *const kfilterByRange = @"filterByRange";
NSString *const kisSorting = @"isSorting";
NSString *const kisFiltering = @"isFiltering";


@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLabelSlider];
    
    cellReload = @[@(0),@(0)];
    _menuListView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.horizontalUI.frame.size.width, self.horizontalUI.frame.size.height)];
    
   menuItems = @[@"SORT BY",@"FILTER"];
    _menuListView.delegate = self;
    _menuListView.dataSource = self;
    [_menuListView setBackgroundColor:[UIColor clearColor]];
    [self.horizontalUI addSubview:_menuListView];
    [_menuListView setSelectedButtonIndex:0];
    [_filterSegment setHidden:YES];
    [_sortSegment setHidden:NO];

    
    [self animateViewIn];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    
    dict_filterSortingParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",ksortByFavouriteStylist,@"",ksortByDistance,@"",ksortByRating,@"",kfilterBySex,@"",kfilterByTime,@"",kfilterByRange,@"YES",kisSorting,@"NO",kisFiltering, nil];
    
    // Do any additional setup after loading the view.
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

- (IBAction)doneClicked:(UIButton *)sender {
        
    if (self.callback !=nil) {
        self.callback(dict_filterSortingParams);
    }

    [self animateViewOut];
}

- (IBAction)DistanceClicked:(UIButton *)sender {
    
    [[view_salonRatingBtnContainer subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        [btnInView setBackgroundColor:[UIColor clearColor]];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [[view_stylistBtnContainer subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        [btnInView setBackgroundColor:[UIColor clearColor]];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [dict_filterSortingParams setObject:@"NO" forKey:ksortByRating];
    [dict_filterSortingParams setObject:@"YES" forKey:ksortByDistance];
    [dict_filterSortingParams setObject:@"NO" forKey:ksortByFavouriteStylist];

    UIButton *btn = (UIButton*)sender;
    
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor colorWithRed:79.0/255.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    
}
- (IBAction)SallonRatingClicked:(UIButton *)sender {
    
    [[view_distanceBtnContainer subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        [btnInView setBackgroundColor:[UIColor clearColor]];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [[view_stylistBtnContainer subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        [btnInView setBackgroundColor:[UIColor clearColor]];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [dict_filterSortingParams setObject:@"YES" forKey:ksortByRating];
    [dict_filterSortingParams setObject:@"NO" forKey:ksortByDistance];
    [dict_filterSortingParams setObject:@"NO" forKey:ksortByFavouriteStylist];

    UIButton *btn = (UIButton*)sender;
    
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor colorWithRed:79.0/255.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
}

- (IBAction)action_sortBystylistClicked:(id)sender {
    
    [[view_distanceBtnContainer subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        [btnInView setBackgroundColor:[UIColor clearColor]];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [[view_salonRatingBtnContainer subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        [btnInView setBackgroundColor:[UIColor clearColor]];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [dict_filterSortingParams setObject:@"NO" forKey:ksortByRating];
    [dict_filterSortingParams setObject:@"NO" forKey:ksortByDistance];
    [dict_filterSortingParams setObject:@"YES" forKey:ksortByFavouriteStylist];

    
    UIButton *btn = (UIButton*)sender;
    
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor colorWithRed:79.0/255.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    
    //push another controller on done callback
}

- (IBAction)genderFilter:(UIButton *)sender {
    
    NSString *string_sex;
    
    if ([sender tag] == 10) {
        string_sex = @"F";
        [self.btn_female setSelected:YES];
        [self.btn_male setSelected:NO];
    }else{
        string_sex = @"M";
        [self.btn_female setSelected:NO];
        [self.btn_male setSelected:YES];
    }
    
    [dict_filterSortingParams setObject:string_sex forKey:kfilterBySex];
}




- (IBAction)cancelTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self animateViewOut];
    }
}



-(void)animateViewIn{
    [UIView animateWithDuration:0.30 animations:^{
        CGRect leftFrame = self.animatedView.frame;
        leftFrame.origin.x = 0;
        [self.animatedView setFrame:leftFrame];
        
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)animateViewOut{
    
    [UIView animateWithDuration:0.30 animations:^{
        CGRect leftFrame = self.animatedView.frame;
        leftFrame.origin.x = leftFrame.size.width;
        [self.animatedView setFrame:leftFrame];
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

-(void)refreshSortByUI{

    [view_salonRatingBtnContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        btnInView.backgroundColor = [UIColor clearColor];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [view_distanceBtnContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        btnInView.backgroundColor = [UIColor clearColor];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
    [view_stylistBtnContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        btnInView.backgroundColor = [UIColor clearColor];
        [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }];
    
}

-(void)refreshFilterByUI{
    
    self.txt_time.text = @"9:00";
    self.txt_ampm.text = @"AM";
    [self.btn_female setSelected:NO];
    [self.btn_male setSelected:NO];
    
}

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return menuItems.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return menuItems[index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        
        [dict_filterSortingParams setObject:@"" forKey:kfilterByTime];
        [dict_filterSortingParams setObject:@"" forKey:kfilterBySex];
        [dict_filterSortingParams setObject:@"" forKey:kfilterByRange];
        [dict_filterSortingParams setObject:@"NO" forKey:kisFiltering];
        [dict_filterSortingParams setObject:@"YES" forKey:kisSorting];

        [self refreshFilterByUI];
        
        [_filterSegment setHidden:YES];
        [_sortSegment setHidden:NO];
    }
    else{
        
        [dict_filterSortingParams setObject:@"" forKey:ksortByDistance];
        [dict_filterSortingParams setObject:@"" forKey:ksortByRating];
        [dict_filterSortingParams setObject:@"YES" forKey:kisFiltering];
        [dict_filterSortingParams setObject:@"NO" forKey:kisSorting];
        
        [self refreshSortByUI];
        
        [_filterSegment setHidden:NO];
        [_sortSegment setHidden:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cellReload[section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* idt = @"filterCell";
    FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:idt];
    
    if (indexPath.section == 1) {
        static NSString* idts = @"cell";
        UITableViewCell *cellt = [tableView dequeueReusableCellWithIdentifier:idts];
        return cellt;
    }
    
    return cell;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _sortByHeader;
    }
    else{
        return _filterHeader;
    }
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 216;
    }
    return 1;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSNumber *check = cellReload[0];
    if ([check isEqual: @(0)]) {
        cellReload = @[@(1),@(0)];
    }
    else{
        
        cellReload = @[@(0),@(0)];
    }
    
    [_filterTable reloadData];
    
    return NO;
}



- (IBAction)action_datePicker:(id)sender {

    UIDatePicker *datePicker = (UIDatePicker*)sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *string_time = [dateFormatter stringFromDate:datePicker.date];
    
    NSArray *arrTime = [string_time componentsSeparatedByString:@" "];
    
    self.txt_time.text = [arrTime objectAtIndex:0];
    self.txt_ampm.text = [arrTime objectAtIndex:1];
    
    [dict_filterSortingParams setObject:self.txt_time.text forKey:kfilterByTime];

}

#pragma mark - Double Slider Methods & Delegates

- (void) configureLabelSlider
{
    self.doubleSlider.minimumValue = 0;
    self.doubleSlider.maximumValue = 24;
    
    self.doubleSlider.lowerValue = 0;
    self.doubleSlider.upperValue = 24;
    
    self.doubleSlider.minimumRange = 1;
}

- (IBAction)doubleSliderChanged:(id)sender {
    [self updateSliderLabels];
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews

    self.label_doubleSlider.text = [NSString stringWithFormat:@"FROM %d TO %d",(int)self.doubleSlider.lowerValue,(int)self.doubleSlider.upperValue];
}


@end
