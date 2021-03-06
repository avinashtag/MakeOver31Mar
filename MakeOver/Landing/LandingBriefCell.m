//
//  LandingBriefCell.m
//  MakeOver
//
//  Created by Himanshu Yadav on 01/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "LandingBriefCell.h"

@implementation LandingBriefCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.contentView.backgroundColor = self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    layout.itemSize = CGSizeMake(80, 80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[StylistCollectionView alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height-20) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.lblStylistCategory = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, self.bounds.size.width-20, 20)];
    self.lblStylistCategory.textColor = [UIColor whiteColor];
    self.lblStylistCategory.backgroundColor = [UIColor clearColor];
//    self.lblStylistCategory.backgroundColor = [UIColor greenColor];

//    self.lblStylistCategory.alpha = 1.0;
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lblStylistCategory];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height-20);
}

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSIndexPath*)iPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.tag = iPath.row;
    
    self.collectionView.tableSectionIndex = iPath.section;
    
    [self.collectionView reloadData];
}

@end
