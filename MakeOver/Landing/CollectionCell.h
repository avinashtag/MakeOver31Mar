//
//  CollectionCell.h
//  MakeOver
//
//  Created by Ekta on 07/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DoFavStylist)(id sender);
@interface CollectionCell : UICollectionViewCell <UIScrollViewDelegate>

@property(weak, nonatomic) IBOutlet UIScrollView * scrollView_imageViewContainer;
@property(weak, nonatomic) IBOutlet UIImageView* imageView;
@property(weak, nonatomic) IBOutlet UIButton* favourite;
@property(weak, nonatomic) IBOutlet UILabel* review;
@property(strong, nonatomic) DoFavStylist doFavStylist;
@property(weak, nonatomic) IBOutlet UIButton* btnCancel_imageSviwer;

-(IBAction)favStylist:(id)sender;

-(void)doFavStylistCompletion:(DoFavStylist)block;

@end
