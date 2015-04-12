//
//  ContactListViewerController.m
//  MakeOver
//
//  Created by Himanshu Yadav on 12/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "ContactListViewerController.h"

@implementation ContactListViewerController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self.tableView_contacts reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array_contacts.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* idt = @"ContactIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idt];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idt];
    }
    
    cell.textLabel.text = self.array_contacts[indexPath.row];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // call this number
    NSString *number = self.array_contacts[indexPath.row];
    
}

@end
