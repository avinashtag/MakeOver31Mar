//
//  RatingViewController.h
//  MakeOver
//
//  Created by Avinash Tag on 16/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

typedef void (^RatingCompletion)(NSString* review , double rating ,BOOL isCancelled) ;
@interface RatingViewController : UIViewController

@property (strong, nonatomic) IBOutlet ASStarRatingView *starRating;
@property (strong, nonatomic) IBOutlet UITextView *reviewDescription;
@property (strong, nonatomic) RatingCompletion ratingcompletion;

- (void)ratingCompletion:(RatingCompletion)completion;
@end
