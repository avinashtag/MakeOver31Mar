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
@property(nonatomic, strong)NSString *saloonMainArea;
@property(nonatomic, strong)NSString *saloonInfo;


@property(nonatomic, strong)NSString *saloonContact;
@property(nonatomic, strong)NSString *saloonDstfrmCurrLocation;
@property(nonatomic, strong)NSString *saloonId;
@property(nonatomic, strong)NSString *saloonName;
@property(nonatomic, strong)NSNumber *sallonReviewCount;
@property(nonatomic, strong)NSString *saloonLat;
@property(nonatomic, strong)NSString *saloonLong;
@property(nonatomic, strong)NSNumber *saloonRating;
@property(nonatomic, strong)NSArray  *saloonServices;
@property(nonatomic, strong)NSArray  *styleList;
@property(nonatomic, strong)NSArray  *services;
@property(nonatomic, strong)NSNumber  *faborateFlag;
@property(nonatomic, strong)NSString *gender;
@property(nonatomic, strong)NSString *startTime;
@property(nonatomic, strong)NSString *endTime;
@property(nonatomic, strong)NSArray  *menuImages;
@property(nonatomic, strong)NSArray  *contacts;
@property(nonatomic, strong)NSArray  *clubImages;
@property(nonatomic, strong)NSString *creditDebitCardSupport;
@property(nonatomic, strong)NSString *startTimeDecimal;
@property(nonatomic, strong)NSString *endTimeDecimal;
@property(nonatomic, strong)NSString *saloonProducts;

@property(nonatomic, strong)id extraParams;



-(instancetype)initWithDictionary:(NSDictionary*)dictioanry;
+(NSArray*)initializeWithResponse:(NSDictionary*)dictionary;
+(NSArray*)initializeWithTutorialResponse:(NSDictionary*)dictionary;
+(NSArray*)initializeWithOffersResponse:(NSDictionary*)dictionary;
+(NSArray*)initializeWithFavStylistsResponse:(NSDictionary*)dictionary;


@end
