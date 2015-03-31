//
//  City.m
//  MakeOver
//
//  Created by Avinash Tag on 24/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "City.h"

@implementation City

static NSString *kCityId = @"city_id";
static NSString *kCityName = @"cityName";


static NSString *kresponseObject = @"object";

-(instancetype)initWithDictionary:(NSDictionary*)dictioanry{
    
    self = [super init];
    self.cityId = [NSString stringWithFormat:@"%@",dictioanry[kCityId]];
    self.cityName = dictioanry[kCityName];
    
    return self;
}

+(NSArray*)initializeWithResponse:(NSDictionary*)dictionary{
    
    __block NSMutableArray *cities = [[NSMutableArray alloc]init];
    NSArray* response = dictionary[kresponseObject];
    [response enumerateObjectsUsingBlock:^(NSDictionary *cityRaw, NSUInteger idx, BOOL *stop) {
       
        City *city = [[City alloc]initWithDictionary:cityRaw];
        [cities addObject:city];
        
    }];
    return cities;
    
}
@end
