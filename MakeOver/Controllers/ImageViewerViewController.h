//
//  ImageViewerViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 18/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@property(strong, nonatomic) NSArray *images;
@property (nonatomic, assign) NSIndexPath *startImageIndexPath;

@end
