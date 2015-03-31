//
//  SallonResponse.h
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SallonResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *saloonRating;
@property (nonatomic, assign) id saloonContact;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, assign) double saloonId;
@property (nonatomic, assign) double sallonReviewCount;
@property (nonatomic, strong) NSString *saloonDstfrmCurrLocation;
@property (nonatomic, strong) NSString *saloonName;
@property (nonatomic, strong) NSString *saloonServices;
@property (nonatomic, assign) id faborateFlag;
@property (nonatomic, strong) NSString *saloonAddress;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
