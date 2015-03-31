//
//  CollectionCell.m
//  MakeOver
//
//  Created by Ekta on 07/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

-(IBAction)favStylist:(id)sender{
    if (_doFavStylist) {
        _doFavStylist(sender);
    }
}

-(void)doFavStylistCompletion:(DoFavStylist)block{
    _doFavStylist = block;
}
@end
