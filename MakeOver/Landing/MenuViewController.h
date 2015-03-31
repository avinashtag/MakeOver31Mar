//
//  MenuViewController.h
//  MakeOver
//
//  Created by Ekta on 07/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceList.h"

@interface MenuViewController : UIViewController


@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;
@property(strong, nonatomic) NSArray *images;



@end
