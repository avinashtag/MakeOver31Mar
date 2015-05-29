//
//  ImageViewerViewController.m
//  MakeOver
//
//  Created by Avinash Tag on 18/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "ImageViewerViewController.h"
#import "CollectionCell.h"
#import "UIImageView+WebCache.h"

@interface ImageViewerViewController ()

@end

@implementation ImageViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isTextDescription) {
        _imageCollection.hidden = YES;
        self.textVw_description.hidden = NO;
        self.textVw_description.text = self.text_description;
    }else{
        self.textVw_description.hidden = YES;
        _imageCollection.hidden = NO;
        [_imageCollection reloadData];
    }


//    [_imageCollection scrollToItemAtIndexPath:_startImageIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [_imageCollection scrollToItemAtIndexPath:_startImageIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idt = @"collectionCellImage";
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idt forIndexPath:indexPath];
    //[cell.imageView setImageWithURL:[NSURL URLWithString:@"https://graph.facebook.com/794134670660627/picture?type=normal"] placeholderImage:nil];
    [cell.imageView setImageWithURL:[NSURL URLWithString:_images[indexPath.row]] placeholderImage:nil];
    
    return cell;
}


@end
