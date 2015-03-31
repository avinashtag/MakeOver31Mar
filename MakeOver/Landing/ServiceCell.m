//
//  ServiceCell.m
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "ServiceCell.h"
#import "CollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation ServiceCollectionCell



@end

@implementation ServiceCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    _startRatingView.canEdit = NO;
    _startRatingView.maxRating = 5;
//    StarRatingView* starview = [[StarRatingView alloc]initWithFrame:CGRectMake(50, 50, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:60 withLabel:YES animated:NO];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionImages.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:_collectionIdentifier forIndexPath:indexPath];
    
//    UIImage* image = [_collectionImages objectAtIndex:indexPath.row];
    
//    [collectionCell.imageView setImageWithURL:[NSURL URLWithString:_collectionImages[indexPath.row]]];
//    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_collectionImages[indexPath.row]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionCell.imageView setImage:image];
        });
    });
    return collectionCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_collectionCompletionBlock!=nil) {
        CollectionCell *collectionCell = (CollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        _collectionCompletionBlock(indexPath,collectionCell.imageView.image);
    }
}

-(void)collectionCellIdentifier:(NSString*)identifierName didSelectCell:(CollectionDidSelect)block{
    
    _collectionIdentifier=identifierName;
    _collectionCompletionBlock = block;
    [_collection reloadData];
}



- (IBAction)callCompletion:(UIButton *)sender{
    if(_collectionReviewDidSelect != nil){
        _collectionReviewDidSelect(sender , tCall);
    }

}

- (IBAction)menuCompletion:(UIButton *)sender{
    if(_collectionReviewDidSelect != nil){
        _collectionReviewDidSelect(sender , tMenu);
    }

}

- (IBAction)photoCompletion:(UIButton *)sender{
    if(_collectionReviewDidSelect != nil){
        _collectionReviewDidSelect(sender , tPhoto);
    }

}

- (IBAction)distanceCompletion:(UIButton *)sender{
//    if(_collectionReviewDidSelect != nil){
//        _collectionReviewDidSelect(sender , tDistance);
//    }
//
}

- (IBAction)favouriteCompletion:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}

- (IBAction)reviewCompletion:(UIButton *)sender{
    
    if(_collectionReviewDidSelect != nil){
        _collectionReviewDidSelect(sender , tReview);
    }
}

- (IBAction)checkInCompletion:(UIButton *)sender{
    if(_collectionReviewDidSelect != nil){
        _collectionReviewDidSelect(sender , tCheckIn);
    }

}

- (IBAction)LikeItCompletion:(UIButton *)sender{
    if(_collectionReviewDidSelect != nil){
        _collectionReviewDidSelect(sender , tRate);
    }
    
}

- (IBAction)infoCompletion:(id)sender {
    
    if(_collectionReviewDidSelect != nil){
        _collectionReviewDidSelect(sender , tInfo);
    }

}

- (void)reviewWithCompletion:(CollectionReviewDidSelect)block{
    
    _collectionReviewDidSelect = block;
}

@end
