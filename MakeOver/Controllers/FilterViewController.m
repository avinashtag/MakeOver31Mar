//
//  FilterViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 22/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "FilterViewController.h"



@implementation FilterCell





@end
@interface FilterViewController (){
    NSArray *menuItems;
    NSArray *cellReload;
}

@end

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
    [self animateViewOut];
}

- (IBAction)DistanceClicked:(UIButton *)sender {
}
- (IBAction)SallonRatingClicked:(UIButton *)sender {
    
}

- (IBAction)genderFilter:(UIButton *)sender {
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


- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return menuItems.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return menuItems[index];
}


- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        [_filterSegment setHidden:YES];
        [_sortSegment setHidden:NO];
    }
    else{
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
    return 60;
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


@end
