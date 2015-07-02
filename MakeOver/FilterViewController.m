//
//  FilterViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 22/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "FilterViewController.h"
#import "NMRangeSlider.h"
#import "UtilityClass.h"

NSString *const ksortByFavouriteStylist = @"sortByFavouriteStylist";
NSString *const ksortByDistance = @"sortByDistance";
NSString *const ksortByRating = @"sortByRating";
NSString *const kfilterBySex = @"filterBySex";
NSString *const kfilterByTime = @"filterByTime";
NSString *const kfilterByRange = @"filterByRange";
NSString *const kfilterByCardSupport = @"filterByCardPresent";

NSString *const kisSorting = @"isSorting";
NSString *const kisFiltering = @"isFiltering";


@implementation FilterCell


@end
@interface FilterViewController (){
    NSArray *menuItems;
    NSArray *cellReload;
    
    BOOL isNeedToRefreshCardButton;
}

@end




@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dict_filterSortingParams = [UtilityClass RetrieveDataFromUserDefault:@"sortNfilter"];
    
    // Do any additional setup after loading the view.
    
    self.label_doubleSlider.text = @"FROM 0 TO 12";

    cellReload = @[@(0),@(0)];
    _menuListView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.horizontalUI.frame.size.width, self.horizontalUI.frame.size.height)];
    
   menuItems = @[@"SORT BY",@"FILTER"];
    _menuListView.delegate = self;
    _menuListView.dataSource = self;
    [_menuListView setBackgroundColor:[UIColor clearColor]];
    [self.horizontalUI addSubview:_menuListView];
    [_menuListView setSelectedButtonIndex:0];
    [_filterSegment setHidden:YES];
//    _btn_clearFilters.hidden = YES;
    [_sortSegment setHidden:NO];

    [self refreshSortByUI];
    
    [self animateViewIn];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

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
    
    if (_menuListView.selectedButtonIndex == 0) {
        
        [dict_filterSortingParams setObject:@"" forKey:kfilterByTime];
        [dict_filterSortingParams setObject:@"" forKey:kfilterBySex];
        [dict_filterSortingParams setObject:@"" forKey:kfilterByRange];
        [dict_filterSortingParams setObject:@"" forKey:kfilterByCardSupport];

        [dict_filterSortingParams setObject:@"NO" forKey:kisFiltering];
        [dict_filterSortingParams setObject:@"YES" forKey:kisSorting];
    }
    else {
        [dict_filterSortingParams setObject:@"" forKey:ksortByDistance];
        [dict_filterSortingParams setObject:@"" forKey:ksortByRating];
        [dict_filterSortingParams setObject:@"" forKey:ksortByFavouriteStylist];
        
        [dict_filterSortingParams setObject:@"YES" forKey:kisFiltering];
        [dict_filterSortingParams setObject:@"NO" forKey:kisSorting];
    }
    
    [UtilityClass SaveDatatoUserDefault:dict_filterSortingParams :@"sortNfilter"];
    
    if (self.callback != nil) {
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
    
//    UIButton *btn = (UIButton*)sender;
    
    if (_menuListView.selectedButtonIndex == 0) // clear sorting
    {
        [dict_filterSortingParams setObject:@"NO" forKey:ksortByRating];
        [dict_filterSortingParams setObject:@"NO" forKey:ksortByDistance];
        [dict_filterSortingParams setObject:@"NO" forKey:ksortByFavouriteStylist];
        
        [dict_filterSortingParams setObject:@"NO" forKey:kisSorting];
    }
    else { // clear filters
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
        
        [dict_filterSortingParams setObject:@"NO" forKey:kisFiltering];
    }
    
}

-(void)refreshFilterByUI{
    
    if ([[dict_filterSortingParams objectForKey:kfilterBySex] length]) {
        
        NSString *string_sex = [dict_filterSortingParams objectForKey:kfilterBySex];

        if ([string_sex isEqualToString:@"U"]) {
            self.btn_female.selected = YES;
            self.btn_male.selected = YES;
        }
        else if ([string_sex isEqualToString:@"F"]) {
            self.btn_female.selected = YES;
            self.btn_male.selected = NO;
        }
        else if ([string_sex isEqualToString:@"M"]) {
            self.btn_female.selected = NO;
            self.btn_male.selected = YES;
        }
        else {
            self.btn_female.selected = NO;
            self.btn_male.selected = NO;
        }
    }
    
    if ([[dict_filterSortingParams objectForKey:kfilterByRange] boolValue])
    {
        
        if (![[dict_filterSortingParams objectForKey:@"filterByRange_lower"] isEqualToString:@"0"])
        {
            NSMutableString *formatedDate = [dict_filterSortingParams objectForKey:@"filterByRange_lower"];
            NSInteger hrs = [[formatedDate substringWithRange:NSMakeRange(0, 2)] integerValue];
            
            if (hrs/12) {
                NSString *realHrs = [NSString stringWithFormat:@"%i",hrs%12];
                [self.btn_fromTime setTitle:[formatedDate stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:realHrs] forState:UIControlStateNormal];
            }
            else
                [self.btn_fromTime setTitle:formatedDate forState:UIControlStateNormal];
        }
        
        if (![[dict_filterSortingParams objectForKey:@"filterByRange_upper"] isEqualToString:@"0"]) {
            
            NSMutableString *formatedDate = [dict_filterSortingParams objectForKey:@"filterByRange_upper"];
            NSInteger hrs = [[formatedDate substringWithRange:NSMakeRange(0, 2)] integerValue];
            
            if (hrs/12) {
                NSString *realHrs = [NSString stringWithFormat:@"%i",hrs%12];
                [self.btn_toTime setTitle:[formatedDate stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:realHrs] forState:UIControlStateNormal];
            }
            else
                [self.btn_toTime setTitle:formatedDate forState:UIControlStateNormal];
        }
    }
    
    
    if ([[dict_filterSortingParams objectForKey:kfilterByCardSupport] isEqualToString:@"Y"])
        isNeedToRefreshCardButton = NO;
    else
        isNeedToRefreshCardButton = YES;
    
    [_filterTable reloadData];
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
        leftFrame.origin.x = leftFrame.origin.x + leftFrame.size.width;
        [self.animatedView setFrame:leftFrame];
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

-(void)refreshSortByUI{

    
    [view_salonRatingBtnContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;
        
        if (![[dict_filterSortingParams objectForKey:ksortByRating] boolValue]) {
            btnInView.backgroundColor = [UIColor clearColor];
            [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            [btnInView setBackgroundColor:[UIColor whiteColor]];
            [btnInView setTitleColor:[UIColor colorWithRed:79.0/255.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        }
        
    }];

    
    
    [view_distanceBtnContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btnInView = (UIButton*)obj;

        if (![[dict_filterSortingParams objectForKey:ksortByDistance] boolValue]) {
            btnInView.backgroundColor = [UIColor clearColor];
            [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            [btnInView setBackgroundColor:[UIColor whiteColor]];
            [btnInView setTitleColor:[UIColor colorWithRed:79.0/255.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        }
        
    }];
    
    
        [view_stylistBtnContainer.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            UIButton *btnInView = (UIButton*)obj;
            
            if (![[dict_filterSortingParams objectForKey:ksortByFavouriteStylist] boolValue]) {
                btnInView.backgroundColor = [UIColor clearColor];
                [btnInView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else {
                [btnInView setBackgroundColor:[UIColor whiteColor]];
                [btnInView setTitleColor:[UIColor colorWithRed:79.0/255.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
            }

            
        }];
    
}


#pragma mark- selectionMenu Delegates
- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return menuItems.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return menuItems[index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
 
    if (index == 0) {
        
        [self refreshSortByUI];
        
        [_filterSegment setHidden:YES];
        [_sortSegment setHidden:NO];
//        _btn_clearFilters.hidden = YES;
    }
    else {
        
        [self refreshFilterByUI];

//        _btn_clearFilters.hidden = NO;
        [_filterSegment setHidden:NO];
        [_sortSegment setHidden:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString* card = @"cellCard";
        UITableViewCell *cellCard = [tableView dequeueReusableCellWithIdentifier:card];
    
        if (indexPath.row == 0) {
            UIButton *btn = (UIButton*)[cellCard viewWithTag:21];

            
            
            [btn addTarget:self action:@selector(cardSupportFilter:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isNeedToRefreshCardButton == YES)
                btn.selected = NO;
            else
                btn.selected = YES;
        }
//        }else if (indexPath.row == 1){
//            UIButton *btn = (UIButton*)[cellCard viewWithTag:21];
//            btn.frame = cellCard.frame;
//            //[btn setImage:[UIImage imageNamed:@"ic_delete"] forState:UIControlStateNormal];
//            [btn setTitle:@"Clear All Filter" forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(clearFilter:) forControlEvents:UIControlEventTouchUpInside];
//            [cellCard.contentView addSubview:btn];
//        }

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

    NSMutableString *formatedDate = [[dateFormatter stringFromDate:self.timePicker.date] mutableCopy];
    
    NSInteger hrs = [[formatedDate substringWithRange:NSMakeRange(0, 2)] integerValue];
    
    if (self.timePicker.tag == 1)
    {
        if (hrs/12) {
            NSString *realHrs = [NSString stringWithFormat:@"%i",hrs%12];
            [self.btn_fromTime setTitle:[formatedDate stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:realHrs] forState:UIControlStateNormal];
        }
        else
            [self.btn_fromTime setTitle:formatedDate forState:UIControlStateNormal];
        
        [dict_filterSortingParams setObject:formatedDate forKey:@"filterByRange_lower"];
    }
    else {
        
        if (hrs/12) {
            NSString *realHrs = [NSString stringWithFormat:@"%i",hrs%12];
            [self.btn_toTime setTitle:[formatedDate stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:realHrs] forState:UIControlStateNormal];
        }
        else
            [self.btn_toTime setTitle:formatedDate forState:UIControlStateNormal];

        [dict_filterSortingParams setObject:formatedDate forKey:@"filterByRange_upper"];
    }

    [dict_filterSortingParams setObject:@"YES" forKey:kisFiltering];
    [dict_filterSortingParams setObject:@"YES" forKey:kfilterByRange];
}


@end
