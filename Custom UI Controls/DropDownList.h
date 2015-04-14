//
//  DropDownList.h
//  MakeOver
//
//  Created by Himanshu Yadav on 14/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownListPassValueDelegate;

@interface DropDownList : UITableViewController {
    NSString		*_searchText;
    NSString		*_selectedText;
    NSMutableArray	*_resultList;
    NSMutableArray	*_resultListWithExtraObj;
   __unsafe_unretained id <DropDownListPassValueDelegate>	_delegate;
}

@property (nonatomic, copy)NSString		*_searchText;
@property (nonatomic, copy)NSString		*_selectedText;
@property (nonatomic, retain)NSMutableArray	*_resultList;
@property (assign) id <DropDownListPassValueDelegate> _delegate;

- (void)updateDataWithArray:(NSArray*)array;


@end
