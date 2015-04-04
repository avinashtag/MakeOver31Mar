//
//  LandingBriefCell.h
//  MakeOver
//
//  Created by Himanshu Yadav on 01/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistCollectionView.h"

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface LandingBriefCell : UITableViewCell

@property (nonatomic, strong) StylistCollectionView *collectionView;
@property (nonatomic, strong) UILabel *lblStylistCategory;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSIndexPath*)iPath;

@end
