//
//  HTHorizontalSelectionList.h
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

@import UIKit;

@protocol HTHorizontalSelectionListDataSource;
@protocol HTHorizontalSelectionListDelegate;

typedef NS_ENUM(NSInteger, HTHorizontalSelectionIndicatorStyle) {
    HTHorizontalSelectionIndicatorStyleBottomBar,           // Default
    HTHorizontalSelectionIndicatorStyleButtonBorder
};

@interface HTHorizontalSelectionList : UIView

@property (nonatomic) NSInteger selectedButtonIndex;

@property (nonatomic, weak) id<HTHorizontalSelectionListDataSource> dataSource;
@property (nonatomic, weak) id<HTHorizontalSelectionListDelegate> delegate;

@property (nonatomic, strong) UIColor *selectionIndicatorColor;
@property (nonatomic, strong) UIColor *bottomTrimColor;

@property (nonatomic) UIEdgeInsets buttonInsets;

@property (nonatomic) HTHorizontalSelectionIndicatorStyle selectionIndicatorStyle;

@property (nonatomic, strong) NSMutableArray *buttons;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

- (void)reloadData;

- (void)buttonWasTapped:(id)sender;

@end

@protocol HTHorizontalSelectionListDataSource <NSObject>

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList;
- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index;

@end

@protocol HTHorizontalSelectionListDelegate <NSObject>

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index;

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
