//
//  StyleList.m
//  MakeOver
//
//  Created by Avinash Tag on 24/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "StyleList.h"
#import "NSObject+MOObject.h"

@implementation StyleList

static NSString *kstyListImgUrl = @"styListImgUrl";
static NSString *kstylistName = @"stylistName";
static NSString *kstylistresp = @"stylistresp";
static NSString *kservices = @"services";
static NSString *kgroups = @"groups";

static NSString *kfaborateFlag = @"faborateFlag";
static NSString *kstylishId = @"stylishId";
static NSString *kstylishPosition = @"stylishPosition";
static NSString *kstylistFabCount = @"stylistFabCount";


-(instancetype)initWithDictionary:(NSDictionary*)dictioanry{
    
    self = [super init];
    self.imageUrl                    = nullRemover(dictioanry[kstyListImgUrl]);
    self.name                        = nullRemover(dictioanry[kstylistName]);
    self.faborateFlag                = @([nullRemover(dictioanry[kfaborateFlag]) boolValue]);
    self.stylishId                   = nullRemover(dictioanry[kstylishId]);
    self.stylishPosition                        = nullRemover(dictioanry[kstylishPosition]);
    self.stylistFabCount                        = @([nullRemover(dictioanry[kstylistFabCount]) doubleValue]);
    return self;
}

+(NSArray*)initializeWithResponse:(NSDictionary*)dictionary{
    
    __block NSMutableArray *services = [[NSMutableArray alloc]init];
    
    
    NSArray* response = dictionary[kservices];
    [response enumerateObjectsUsingBlock:^(NSDictionary *ServiceRaw, NSUInteger idx, BOOL *stop) {
        
        NSArray *temp = ServiceRaw[kgroups];
        [temp enumerateObjectsUsingBlock:^(NSDictionary *grp, NSUInteger idx, BOOL *stop) {
           
            NSArray *stylist = grp[kstylistresp];
            [stylist enumerateObjectsUsingBlock:^(NSDictionary *stylst, NSUInteger idx, BOOL *stop) {
                StyleList *service = [[StyleList alloc]initWithDictionary:stylst];
                [services addObject:service];

            }];
        }];
        
    }];
    
    
    return services;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.faborateFlag forKey:@"faborateFlag"];
    [encoder encodeObject:self.stylishId forKey:@"stylishId"];
    [encoder encodeObject:self.stylishPosition forKey:@"stylishPosition"];
    [encoder encodeObject:self.stylistFabCount forKey:@"stylistFabCount"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.imageUrl = [decoder decodeObjectForKey:@"salooimageUrlnAddress"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.faborateFlag = [decoder decodeObjectForKey:@"faborateFlag"];
    self.stylishId = [decoder decodeObjectForKey:@"stylishId"];
    self.stylishPosition = [decoder decodeObjectForKey:@"stylishPosition"];
    self.stylistFabCount = [decoder decodeObjectForKey:@"stylistFabCount"];
    
    return self;
}



@end
