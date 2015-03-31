//
//  ServiceList.h
//  MakeOver
//
//  Created by Avinash Tag on 24/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceList : NSObject <NSCoding>


@property(nonatomic, strong)NSString *saloonAddress;
@property(nonatomic, strong)NSString *saloonContact;
@property(nonatomic, strong)NSString *saloonDstfrmCurrLocation;
@property(nonatomic, strong)NSString *saloonId;
@property(nonatomic, strong)NSString *saloonName;
@property(nonatomic, strong)NSNumber *sallonReviewCount;
@property(nonatomic, strong)NSNumber *saloonRating;
@property(nonatomic, strong)NSArray  *saloonServices;
@property(nonatomic, strong)NSArray  *styleList;
@property(nonatomic, strong)NSArray  *services;
@property(nonatomic, strong)NSNumber  *faborateFlag;


-(instancetype)initWithDictionary:(NSDictionary*)dictioanry;
+(NSArray*)initializeWithResponse:(NSDictionary*)dictionary;


@end
