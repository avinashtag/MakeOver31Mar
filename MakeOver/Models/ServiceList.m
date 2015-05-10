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
static NSString *ksaloonMainArea = @"mainArea";

static NSString *ksaloonContact = @"";
static NSString *ksaloonDstfrmCurrLocation = @"saloonDstfrmCurrLocation";
static NSString *ksaloonId = @"saloonId";
static NSString *ksaloonName = @"saloonName";
static NSString *ksaloonRating = @"saloonRating";
static NSString *ksaloonServices = @"saloonServices";
static NSString *kstyList = @"styList";
static NSString *ksallonReviewCount = @"sallonReviewCount";
static NSString *kfaborateFlag = @"faborateFlag";
static NSString *kgender = @"gender";
static NSString *kstartTime = @"startTiming";
static NSString *kendTime = @"endTiming";
static NSString *kmenuImages = @"menuImages";
static NSString *kcontacts = @"saloonContact";
static NSString *kclubImages = @"clubImages";
static NSString *kcreditDebitCardSupport = @"creditDebitCardSupport";
static NSString *kextraParams = @"extraParams";
static NSString *kstartTimeDecimal = @"startTimingDecimal";
static NSString *kendTimeDecimal = @"endTimingDecimal";

static NSString *kresponseObject = @"object";

-(instancetype)initWithDictionary:(NSDictionary*)dictioanry{
    
    self = [super init];
    self.saloonAddress               = nullRemover(dictioanry[ksaloonAddress]);
    self.saloonMainArea               = nullRemover(dictioanry[ksaloonMainArea]);

    self.saloonContact               = nullRemover(dictioanry[ksaloonContact]);
    
    
    if ([nullRemover(dictioanry[ksaloonDstfrmCurrLocation]) length] == 0) {
        self.saloonDstfrmCurrLocation    = @"0.0"; // by default 0
    }else{
        self.saloonDstfrmCurrLocation    = [NSString stringWithFormat:@"%@",nullRemover(dictioanry[ksaloonDstfrmCurrLocation])];
    }
    
    self.saloonId                    = nullRemover(dictioanry[ksaloonId]);
    self.saloonName                  = nullRemover(dictioanry[ksaloonName]);
    self.saloonRating                = @([nullRemover(dictioanry[ksaloonRating]) doubleValue]);
    self.sallonReviewCount                = @([nullRemover(dictioanry[ksallonReviewCount]) doubleValue]);
    self.faborateFlag                = @([nullRemover(dictioanry[kfaborateFlag]) doubleValue]);
    self.gender               = nullRemover(dictioanry[kgender]);
    self.startTime               = nullRemover(dictioanry[kstartTime]);
    self.endTime               = nullRemover(dictioanry[kendTime]);

    
    NSArray *array_startTime = [NSArray arrayWithArray:[nullRemover(dictioanry[kstartTime]) componentsSeparatedByString:@":"]];
    if (array_startTime.count == 2) {
        self.startTimeDecimal              = [NSString stringWithFormat:@"%f",[[array_startTime objectAtIndex:0] floatValue]+[[array_startTime objectAtIndex:1] floatValue]/60];
    }else{
        self.startTimeDecimal               = nullRemover(dictioanry[kstartTime]);
    }
    
    NSArray *array_endTime = [NSArray arrayWithArray:[nullRemover(dictioanry[kendTime]) componentsSeparatedByString:@":"]];
    if (array_endTime.count == 2) {
        self.endTimeDecimal              = [NSString stringWithFormat:@"%f",[[array_endTime objectAtIndex:0] floatValue]+[[array_endTime objectAtIndex:1] floatValue]/60];
    }else{
        self.endTimeDecimal               = nullRemover(dictioanry[kendTime]);
    }
    
    self.creditDebitCardSupport = nullRemover(dictioanry[kcreditDebitCardSupport]);


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

    self.contacts = [NSArray arrayWithArray:[dictioanry objectForKey:kcontacts]];
    self.clubImages = [NSArray arrayWithArray:[dictioanry objectForKey:kclubImages]];
    self.menuImages = [NSArray arrayWithArray:[dictioanry objectForKey:kmenuImages]];
    
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

+(NSArray*)initializeWithTutorialResponse:(NSDictionary*)dictionary{
    
    __block NSMutableArray *services = [[NSMutableArray alloc]init];
    NSArray* response = dictionary[kresponseObject];
    [response enumerateObjectsUsingBlock:^(NSDictionary *ServiceRaw, NSUInteger idx, BOOL *stop) {
        
        ServiceList *service = [[ServiceList alloc]initWithDictionary:[ServiceRaw objectForKey:@"saloonResponse"]];
        
        service.extraParams = [NSArray arrayWithArray:[ServiceRaw objectForKey:@"tutorials"]];
        
        [services addObject:service];
        
    }];
    return services;
}


+(NSArray*)initializeWithOffersResponse:(NSDictionary*)dictionary{
    __block NSMutableArray *services = [[NSMutableArray alloc]init];
    NSArray* response = dictionary[kresponseObject];
    [response enumerateObjectsUsingBlock:^(NSDictionary *ServiceRaw, NSUInteger idx, BOOL *stop) {
        
        ServiceList *service = [[ServiceList alloc]initWithDictionary:[ServiceRaw objectForKey:@"saloonResponse"]];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        for (NSString *key in ServiceRaw.allKeys) {
            if (![key isEqualToString:@"saloonResponse"])
                [dict setObject:[ServiceRaw objectForKey:key] forKey:key];
        }
        
        service.extraParams = dict;
        [services addObject:service];
    }];
    return services;
}


+(NSArray*)initializeWithFavStylistsResponse:(NSDictionary*)dictionary{
    __block NSMutableArray *services = [[NSMutableArray alloc]init];
    NSArray* response = dictionary[kresponseObject];
    [response enumerateObjectsUsingBlock:^(NSDictionary *ServiceRaw, NSUInteger idx, BOOL *stop) {
        
        ServiceList *service = [[ServiceList alloc]initWithDictionary:[ServiceRaw objectForKey:@"saloonResponse"]];
        
        service.extraParams = [NSMutableDictionary dictionaryWithDictionary:[ServiceRaw objectForKey:@"stlitsResponse"]];
        
        [services addObject:service];
        
    }];
    return services;
}

// Implementation
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.saloonAddress forKey:ksaloonAddress];
    [encoder encodeObject:self.saloonMainArea forKey:ksaloonMainArea];

    [encoder encodeObject:self.saloonContact forKey:ksaloonContact];
    [encoder encodeObject:self.saloonDstfrmCurrLocation forKey:ksaloonDstfrmCurrLocation];
    [encoder encodeObject:self.saloonId forKey:ksaloonId];
    [encoder encodeObject:self.saloonName forKey:ksaloonName];
    [encoder encodeObject:self.sallonReviewCount forKey:ksallonReviewCount];
    [encoder encodeObject:self.saloonRating forKey:ksaloonRating];
    [encoder encodeObject:self.saloonServices forKey:ksaloonServices];
    [encoder encodeObject:self.styleList forKey:kstyList];
    [encoder encodeObject:self.services forKey:kObjectServices];
    [encoder encodeObject:self.faborateFlag forKey:kfaborateFlag];
    
    [encoder encodeObject:self.gender forKey:kgender];
    [encoder encodeObject:self.startTime forKey:kstartTime];
    [encoder encodeObject:self.endTime forKey:kendTime];
    [encoder encodeObject:self.menuImages forKey:kmenuImages];
    [encoder encodeObject:self.contacts forKey:kcontacts];
    [encoder encodeObject:self.clubImages forKey:kclubImages];
    [encoder encodeObject:self.creditDebitCardSupport forKey:kcreditDebitCardSupport];

    [encoder encodeObject:self.startTimeDecimal forKey:kstartTimeDecimal];
    [encoder encodeObject:self.endTimeDecimal forKey:kendTimeDecimal];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.saloonAddress = [decoder decodeObjectForKey:ksaloonAddress];
    self.saloonMainArea = [decoder decodeObjectForKey:ksaloonMainArea];

    self.saloonContact = [decoder decodeObjectForKey:ksaloonContact];
    self.saloonDstfrmCurrLocation = [decoder decodeObjectForKey:ksaloonDstfrmCurrLocation];
    self.saloonId = [decoder decodeObjectForKey:ksaloonId];
    self.saloonName = [decoder decodeObjectForKey:ksaloonName];
    self.sallonReviewCount = [decoder decodeObjectForKey:ksallonReviewCount];
    self.saloonRating = [decoder decodeObjectForKey:ksaloonRating];
    self.saloonServices = [decoder decodeObjectForKey:ksaloonServices];
    self.styleList = [decoder decodeObjectForKey:kstyList];
    self.services = [decoder decodeObjectForKey:kObjectServices];
    self.faborateFlag = [decoder decodeObjectForKey:kfaborateFlag];

    self.gender = [decoder decodeObjectForKey:kgender];
    self.startTime = [decoder decodeObjectForKey:kstartTime];
    self.endTime = [decoder decodeObjectForKey:kendTime];
    self.menuImages = [decoder decodeObjectForKey:kmenuImages];
    self.contacts = [decoder decodeObjectForKey:kcontacts];
    self.clubImages = [decoder decodeObjectForKey:kclubImages];
    self.creditDebitCardSupport = [decoder decodeObjectForKey:kcreditDebitCardSupport];

    self.startTimeDecimal = [decoder decodeObjectForKey:kstartTimeDecimal];
    self.endTimeDecimal = [decoder decodeObjectForKey:kendTimeDecimal];
    
    return self;
}




@end
