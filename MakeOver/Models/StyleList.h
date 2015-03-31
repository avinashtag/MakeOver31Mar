//
//  StyleList.h
//  MakeOver
//
//  Created by Avinash Tag on 24/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleList : NSObject <NSCoding>


@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSNumber *faborateFlag;
@property(nonatomic, strong)NSString *stylishId;
@property(nonatomic, strong)NSString *stylishPosition;
@property(nonatomic, strong)NSNumber *stylistFabCount;

-(instancetype)initWithDictionary:(NSDictionary*)dictioanry;
+(NSArray*)initializeWithResponse:(NSDictionary*)dictionary;
@end
