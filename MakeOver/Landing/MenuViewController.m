//
//  MenuViewController.m
//  MakeOver
//
//  Created by Ekta on 07/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "MenuViewController.h"
#import "CollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation MenuViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
}


-(IBAction)cancel:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idt = @"cell";
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idt forIndexPath:indexPath];
//    [cell.imageView setImageWithURL:[NSURL URLWithString:_images[indexPath.row]]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_images[indexPath.row]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:image];
        });
        
        //    [cell.imageView setImageWithURL:[NSURL URLWithString:_images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"5starsgray.png"]];
    });
    return cell;
}

@end
