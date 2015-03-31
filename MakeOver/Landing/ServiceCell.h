//
//  ServiceCell.h
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

typedef enum{
    
    tReview = 0,
    tCall,
    tMenu,
    tPhoto,
    tDistance,
    tFavourite,
    tCheckIn,
    tRate,
    tInfo
} ServiceCollectionType;

@interface ServiceCollectionCell : UICollectionViewCell

typedef void(^CollectionDidSelect)(NSIndexPath* indexpath , UIImage *image);
typedef void(^CollectionReviewDidSelect)(UIButton* sender , ServiceCollectionType serviceType);




@property (strong, nonatomic) IBOutlet UIImageView* serviceImage;
@end

@interface ServiceCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *distance;
@property (strong, nonatomic) IBOutlet UIImageView *genderImage;
@property (strong, nonatomic) IBOutlet UIButton *favourite;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *descriptionService;
@property (strong, nonatomic) IBOutlet ASStarRatingView *startRatingView;
@property (strong, nonatomic) IBOutlet UIButton *reviewCounts;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic) NSString *collectionIdentifier;
@property (strong, nonatomic) NSMutableArray *collectionImages;
@property (strong, nonatomic) CollectionDidSelect collectionCompletionBlock;
@property (strong, nonatomic) CollectionReviewDidSelect collectionReviewDidSelect;

- (IBAction)callCompletion:(UIButton *)sender;
- (IBAction)menuCompletion:(UIButton *)sender;
- (IBAction)photoCompletion:(UIButton *)sender;
- (IBAction)distanceCompletion:(UIButton *)sender;
- (IBAction)favouriteCompletion:(UIButton *)sender;
- (IBAction)reviewCompletion:(UIButton *)sender;
- (IBAction)checkInCompletion:(UIButton *)sender;
- (IBAction)LikeItCompletion:(UIButton *)sender;

-(void)collectionCellIdentifier:(NSString*)identifierName didSelectCell:(CollectionDidSelect)block;
- (void)reviewWithCompletion:(CollectionReviewDidSelect)block;


@end
