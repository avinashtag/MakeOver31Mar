//
//  DropDownList.m
//  MakeOver
//
//  Created by Himanshu Yadav on 14/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "DropDownList.h"
#import <QuartzCore/QuartzCore.h>
#import "DropDownListPassValueDelegate.h"
#import "ServiceList.h"

@implementation DropDownList

@synthesize _searchText, _selectedText, _resultList, _delegate;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
    _searchText = nil;
    _selectedText = nil;
    _resultList = [[NSMutableArray alloc] initWithCapacity:5];
    
}

- (void)updateDataWithArray:(NSArray*)array{
    [_resultList removeAllObjects];
    _resultList = [[NSMutableArray alloc]initWithArray:array];
    
    [_resultList insertObject:[NSString stringWithFormat:@"%d records found..",_resultList.count] atIndex:0];
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_resultList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [_resultList objectAtIndex:0];
    }else{
        ServiceList *listObj = (ServiceList*)[_resultList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = listObj.saloonName;//[_resultList objectAtIndex:row];
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [_delegate firstRowSelectedWithValue:[_resultList objectAtIndex:0]];
    }else{
        [_delegate didSelectRowWithObject:[_resultList objectAtIndex:indexPath.row]];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end
