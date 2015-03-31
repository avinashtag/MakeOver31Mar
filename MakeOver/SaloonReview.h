//
//  SaloonReviewObject.h
//
//  Created by chandan chouksey on 26/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SaloonReview : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *userImgUrl;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *review;
@property (nonatomic, assign) double saloonId;
@property (nonatomic, strong) NSString *reviewDate;
@property (nonatomic, assign) double rating;
@property (nonatomic, strong) NSDate* dateCreated;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
