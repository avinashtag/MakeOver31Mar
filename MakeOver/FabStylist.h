//
//  FabStylist.h
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SallonResponse;

@interface FabStylist : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *stylistMobile;
@property (nonatomic, strong) SallonResponse *sallonResponse;
@property (nonatomic, strong) NSString *stylistName;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, assign) double stylistId;
@property (nonatomic, assign) id rating;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSString *stylishPosition;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
