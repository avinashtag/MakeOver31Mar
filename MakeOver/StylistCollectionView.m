//
//  StylistCollectionView.m
//  MakeOver
//
//  Created by Pankaj Yadav on 04/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "StylistCollectionView.h"

@implementation StylistCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.tableSectionIndex = 0;
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
