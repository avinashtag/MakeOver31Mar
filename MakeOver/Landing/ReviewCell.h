//
//  ReviewCell.h
//  MakeOver
//
//  Created by Avinash Tag on 15/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingView.h"

@interface ReviewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateSubtitle;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *detail;
@property (strong, nonatomic) IBOutlet StarRatingView *startRatingView;
@end
