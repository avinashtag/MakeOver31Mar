//
//  ServiceList.m
//  MakeOver
//
//  Created by Avinash Tag on 24/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "ServiceList.h"
#import "StyleList.h"
#import "NSObject+MOObject.h"
#import "DataModels.h"

NSString *const kObjectServices = @"services";


@implementation ServiceList


static NSString *ksaloonAddress = @"saloonAddress";
static NSString *ksaloonContact = @"saloonContact";
static NSString *ksaloonDstfrmCurrLocation = @"saloonDstfrmCurrLocation";
static NSString *ksaloonId = @"saloonId";
static NSString *ksaloonName = @"saloonName";
static NSString *ksaloonRating = @"saloonRating";
static NSString *ksaloonServices = @"saloonServices";
static NSString *kstyList = @"styList";
static NSString *ksallonReviewCount = @"sallonReviewCount";
static NSString *kfaborateFlag = @"faborateFlag";
static NSString *kgender = @"gender";

static NSString *kresponseObject = @"object";

-(instancetype)initWithDictionary:(NSDictionary*)dictioanry{
    
    self = [super init];
    self.saloonAddress               = nullRemover(dictioanry[ksaloonAddress]);
    self.saloonContact               = nullRemover(dictioanry[ksaloonContact]);
    self.saloonDstfrmCurrLocation    = [NSString stringWithFormat:@"%@",nullRemover(dictioanry[ksaloonDstfrmCurrLocation])];
    self.saloonId                    = nullRemover(dictioanry[ksaloonId]);
    self.saloonName                  = nullRemover(dictioanry[ksaloonName]);
    self.saloonRating                = @([nullRemover(dictioanry[ksaloonRating]) doubleValue]);
    self.sallonReviewCount                = @([nullRemover(dictioanry[ksallonReviewCount]) doubleValue]);
    self.faborateFlag                = @([nullRemover(dictioanry[kfaborateFlag]) doubleValue]);
    self.gender               = nullRemover(dictioanry[kgender]);

    if ([nullRemover(dictioanry[ksaloonServices]) isKindOfClass:[NSArray class]]) {
        self.saloonServices              = nullRemover(dictioanry[ksaloonServices]);
    }
    else if ([nullRemover(dictioanry[ksaloonServices]) isKindOfClass:[NSString class]]){
        self.saloonServices              = [nullRemover(dictioanry[ksaloonServices]) componentsSeparatedByString:@","];
    }
    self.styleList                   = [StyleList initializeWithResponse:dictioanry];
    

    
    NSObject *receivedServices = [dictioanry objectForKey:kObjectServices];
    NSMutableArray *parsedServices = [NSMutableArray array];
    if ([receivedServices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedServices) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedServices addObject:[Services modelObjectWithDictionary:item]];
            }
        }
    } else if ([receivedServices isKindOfClass:[NSDictionary class]]) {
        [parsedServices addObject:[Services modelObjectWithDictionary:(NSDictionary *)receivedServices]];
    }
    self.services = [NSArray arrayWithArray:parsedServices];

    return self;
}



+(NSArray*)initializeWithResponse:(NSDictionary*)dictionary{
    
    __block NSMutableArray *services = [[NSMutableArray alloc]init];
    NSArray* response = dictionary[kresponseObject];
    [response enumerateObjectsUsingBlock:^(NSDictionary *ServiceRaw, NSUInteger idx, BOOL *stop) {
        
        ServiceList *service = [[ServiceList alloc]initWithDictionary:ServiceRaw];
        [services addObject:service];
        
    }];
    return services;
}

// Implementation
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.saloonAddress forKey:@"saloonAddress"];
    [encoder encodeObject:self.saloonContact forKey:@"saloonContact"];
    [encoder encodeObject:self.saloonDstfrmCurrLocation forKey:@"saloonDstfrmCurrLocation"];
    [encoder encodeObject:self.saloonId forKey:@"saloonId"];
    [encoder encodeObject:self.saloonName forKey:@"saloonName"];
    [encoder encodeObject:self.sallonReviewCount forKey:@"sallonReviewCount"];
    [encoder encodeObject:self.saloonRating forKey:@"saloonRating"];
    [encoder encodeObject:self.saloonServices forKey:@"saloonServices"];
    [encoder encodeObject:self.styleList forKey:@"styleList"];
    [encoder encodeObject:self.services forKey:@"services"];
    [encoder encodeObject:self.faborateFlag forKey:@"faborateFlag"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.saloonAddress = [decoder decodeObjectForKey:@"saloonAddress"];
    self.saloonContact = [decoder decodeObjectForKey:@"saloonContact"];
    self.saloonDstfrmCurrLocation = [decoder decodeObjectForKey:@"saloonDstfrmCurrLocation"];
    self.saloonId = [decoder decodeObjectForKey:@"saloonId"];
    self.saloonName = [decoder decodeObjectForKey:@"saloonName"];
    self.sallonReviewCount = [decoder decodeObjectForKey:@"sallonReviewCount"];
    self.saloonRating = [decoder decodeObjectForKey:@"saloonRating"];
    self.saloonServices = [decoder decodeObjectForKey:@"saloonServices"];
    self.styleList = [decoder decodeObjectForKey:@"styleList"];
    self.services = [decoder decodeObjectForKey:@"services"];
    self.faborateFlag = [decoder decodeObjectForKey:@"faborateFlag"];

    return self;
}




@end
