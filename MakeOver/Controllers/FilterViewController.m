//
//  FilterViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 22/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "FilterViewController.h"
#import "NMRangeSlider.h"

@implementation FilterCell





@end
@interface FilterViewController (){
    NSArray *menuItems;
    NSArray *cellReload;
    
    BOOL isNeedToRefreshCardButton;
}

@end

NSString *const ksortByFavouriteStylist = @"sortByFavouriteStylist";
NSString *const ksortByDistance = @"sortByDistance";
NSString *const ksortByRating = @"sortByRating";
NSString *const kfilterBySex = @"filterBySex";
NSString *const kfilterByTime = @"filterByTime";
NSString *const kfilterByRange = @"filterByRange";
NSString *const kfilterByCardSupport = @"filterByCardPresent";

NSString *const kisSorting = @"isSorting";
NSString *const kisFiltering = @"isFiltering";


@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

    
    dict_filterSortingParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",ksortByFavouriteStylist,@"",ksortByDistance,@"",ksortByRating,@"",kfilterBySex,@"",kfilterByTime,@"",kfilterByRange,@"NO",kfilterByCardSupport,@"YES",kisSorting,@"NO",kisFiltering, nil];

    [dict_filterSortingParams setObject:@"0" forKey:@"filterByRange_lower"];
    [dict_filterSortingParams setObject:@"0" forKey:@"filterByRange_upper"];
    // Do any additional setup after loading the view.
    
    self.label_doubleSlider.text = @"FROM 0 TO 24";
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
    
    UIButton *button = (UIButton*)sender;
    
    NSString *string_sex = @"";
    
    if ((button.tag == 10) && button.isSelected == YES) {
        [self.btn_female setSelected:NO];
    }else if ((button.tag == 10) && button.isSelected == NO){
        [self.btn_female setSelected:YES];
    }
    
    if ((button.tag != 10) && button.isSelected == YES) {
        [self.btn_male setSelected:NO];
    }else if ((button.tag != 10) && button.isSelected == NO){
        [self.btn_male setSelected:YES];
    }
    
    if (self.btn_female.isSelected == YES && self.btn_male.isSelected == YES) {
        string_sex = @"U";
    }else if (self.btn_female.isSelected == YES && self.btn_male.isSelected == NO){
        string_sex = @"F";
    }else if (self.btn_female.isSelected == NO && self.btn_male.isSelected == YES){
        string_sex = @"M";
    }else if (self.btn_female.isSelected == NO && self.btn_male.isSelected == NO){
        string_sex = @"";
    }
    [dict_filterSortingParams setObject:string_sex forKey:kfilterBySex];
}


- (IBAction)cardSupportFilter:(UIButton *)sender {
    
    isNeedToRefreshCardButton = NO;
    
    UIButton *btn = (UIButton*)sender;
    
    if (!btn.selected) {
        [btn setSelected:YES];
        [dict_filterSortingParams setObject:@"Y" forKey:kfilterByCardSupport];
    }else{
        [dict_filterSortingParams setObject:@"N" forKey:kfilterByCardSupport];
        [btn setSelected:NO];
    }
    
}


- (IBAction)clearFilter:(UIButton *)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    [self refreshFilterByUI];
    
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
    [self.btn_female setSelected:NO];
    [self.btn_male setSelected:NO];

    isNeedToRefreshCardButton = YES;
    [self.filterTable reloadData];

    [self.btn_fromTime setTitle:@"Select Time" forState:UIControlStateNormal];
    [self.btn_toTime setTitle:@"Select Time" forState:UIControlStateNormal];

    [dict_filterSortingParams setObject:@"" forKey:kfilterByCardSupport];
    [dict_filterSortingParams setObject:@"" forKey:kfilterBySex];
    [dict_filterSortingParams setObject:@"" forKey:kfilterByRange];
    [dict_filterSortingParams setObject:@"" forKey:@"filterByRange_lower"];
    [dict_filterSortingParams setObject:@"" forKey:@"filterByRange_upper"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString* card = @"cellCard";
        UITableViewCell *cellCard = [tableView dequeueReusableCellWithIdentifier:card];
    
        if (indexPath.row == 0) {
            UIButton *btn = (UIButton*)[cellCard viewWithTag:21];
            [btn setImage:[UIImage imageNamed:@"ic_nocards"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"ic_cards"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(cardSupportFilter:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isNeedToRefreshCardButton == YES)
                btn.selected = NO;
            
        }else if (indexPath.row == 1){
            UIButton *btn = (UIButton*)[cellCard viewWithTag:21];
            [btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
            [btn setTitle:@"Clear All Filter" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clearFilter:) forControlEvents:UIControlEventTouchUpInside];
            [cellCard.contentView addSubview:btn];
        }

        cellCard.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cellCard;
    
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _filterHeader;
    }
    else{
        return [[UIView alloc]init];
    }
    
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 60; //return 216;
    }
    if (indexPath.section == 1) {
        return 60;
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

    self.timePicker.date = [NSDate date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.timePicker.date];

    if ([sender tag] == 1) {
        self.timePicker.tag = 1;
        [self.btn_fromTime setTitle:formatedDate forState:UIControlStateNormal];
    }else{
        self.timePicker.tag = 2;
        [self.btn_toTime setTitle:formatedDate forState:UIControlStateNormal];
    }

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view_datePicker.frame;
        frame.origin.y = self.view.frame.size.height - self.view_datePicker.frame.size.height;
        self.view_datePicker.frame = frame;
    }];
}

- (IBAction)action_cancelPicker:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view_datePicker.frame;
        frame.origin.y = self.view.frame.size.height + self.view_datePicker.frame.size.height;
        self.view_datePicker.frame = frame;
    }];
}

- (IBAction)timePickerHelper:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a"];

    NSString *formatedDate = [dateFormatter stringFromDate:self.timePicker.date];

    if (self.timePicker.tag == 1) {
        [self.btn_fromTime setTitle:formatedDate forState:UIControlStateNormal];
        [dict_filterSortingParams setObject:[formatedDate substringToIndex:2] forKey:@"filterByRange_lower"];
    }else{
        [self.btn_toTime setTitle:formatedDate forState:UIControlStateNormal];
        [dict_filterSortingParams setObject:[formatedDate substringToIndex:2] forKey:@"filterByRange_upper"];
    }

    [dict_filterSortingParams setObject:@"YES" forKey:kisFiltering];
    [dict_filterSortingParams setObject:@"YES" forKey:kfilterByRange];
}


@end
