//
//  Groups.m
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Groups.h"


NSString *const kGroupsPosition = @"position";
NSString *const kGroupsStylistresp = @"stylistresp";


@interface Groups ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Groups

@synthesize position = _position;
@synthesize stylistresp = _stylistresp;


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
            self.position = [self objectOrNilForKey:kGroupsPosition fromDictionary:dict];
            self.stylistresp = [self objectOrNilForKey:kGroupsStylistresp fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.position forKey:kGroupsPosition];
    NSMutableArray *tempArrayForStylistresp = [NSMutableArray array];
    for (NSObject *subArrayObject in self.stylistresp) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForStylistresp addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForStylistresp addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForStylistresp] forKey:kGroupsStylistresp];

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

    self.position = [aDecoder decodeObjectForKey:kGroupsPosition];
    self.stylistresp = [aDecoder decodeObjectForKey:kGroupsStylistresp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_position forKey:kGroupsPosition];
    [aCoder encodeObject:_stylistresp forKey:kGroupsStylistresp];
}

- (id)copyWithZone:(NSZone *)zone
{
    Groups *copy = [[Groups alloc] init];
    
    if (copy) {

        copy.position = [self.position copyWithZone:zone];
        copy.stylistresp = [self.stylistresp copyWithZone:zone];
    }
    
    return copy;
}


@end
