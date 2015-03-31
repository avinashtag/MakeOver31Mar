//
//  City.h
//  MakeOver
//
//  Created by Avinash Tag on 24/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;


-(instancetype)initWithDictionary:(NSDictionary*)dictioanry;
+(NSArray*)initializeWithResponse:(NSDictionary*)dictionary;


@end
