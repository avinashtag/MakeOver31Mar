//
//  Services.m
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Services.h"
#import "Groups.h"


NSString *const kServicesServiceName = @"serviceName";
NSString *const kServicesGroups = @"groups";


@interface Services ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Services

@synthesize serviceName = _serviceName;
@synthesize groups = _groups;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.serviceName = [self objectOrNilForKey:kServicesServiceName fromDictionary:dict];



    NSObject *receivedGroups = [dict objectForKey:kServicesGroups];
    NSMutableArray *parsedGroups = [NSMutableArray array];
    if ([receivedGroups isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedGroups) {
            if ([item isKindOfClass:[NSDictionary class]]) {

                NSArray *arrayStylistResp = [item objectForKey:@"stylistresp"];
                if (arrayStylistResp.count != 0) {
                    [parsedGroups addObject:[Groups modelObjectWithDictionary:item]];
                }

            }
       }
    } else if ([receivedGroups isKindOfClass:[NSDictionary class]]) {
       [parsedGroups addObject:[Groups modelObjectWithDictionary:(NSDictionary *)receivedGroups]];
    }

    self.groups = [NSArray arrayWithArray:parsedGroups];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.serviceName forKey:kServicesServiceName];
    NSMutableArray *tempArrayForGroups = [NSMutableArray array];
    for (NSObject *subArrayObject in self.groups) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForGroups addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForGroups addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForGroups] forKey:kServicesGroups];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.serviceName = [aDecoder decodeObjectForKey:kServicesServiceName];
    self.groups = [aDecoder decodeObjectForKey:kServicesGroups];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_serviceName forKey:kServicesServiceName];
    [aCoder encodeObject:_groups forKey:kServicesGroups];
}

- (id)copyWithZone:(NSZone *)zone
{
    Services *copy = [[Services alloc] init];
    
    if (copy) {

        copy.serviceName = [self.serviceName copyWithZone:zone];
        copy.groups = [self.groups copyWithZone:zone];
    }
    
    return copy;
}


@end
