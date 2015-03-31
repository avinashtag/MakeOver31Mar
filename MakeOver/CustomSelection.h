//
//  CustomSelection.h
//  MakeOver
//
//  Created by Avinash Tag on 21/02/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectionCompletion)(NSString* name , NSIndexPath *indexPath);
@interface CustomSelectionCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UILabel *name;


@end


@interface CustomSelection : UITableViewController


@property(nonatomic, strong)NSMutableArray *names;
@property(nonatomic, strong)SelectionCompletion selectionCompletion;

-(void)didSelectedWithComnpletion:(SelectionCompletion)block;

@end
