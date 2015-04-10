//
//  FavouriteStylistButton.h
//  MakeOver
//
//  Created by Himanshu Yadav on 10/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteStylistButton : UIButton{

}
@property(nonatomic,assign)NSUInteger tableSectionIndex;    //for table section
@property(nonatomic,assign)NSUInteger collectionViewIndex;  //Within table section, for collection view
@property(nonatomic,assign)NSUInteger collectionViewCellIndex; //Within CollectionView, for collection view cell in which this button is present

@end
