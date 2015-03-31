//
//  SallonResponse.m
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SallonResponse.h"
#import "Services.h"


NSString *const kSallonResponseSaloonRating = @"saloonRating";
NSString *const kSallonResponseSaloonContact = @"saloonContact";
NSString *const kSallonResponseServices = @"services";
NSString *const kSallonResponseSaloonId = @"saloonId";
NSString *const kSallonResponseSallonReviewCount = @"sallonReviewCount";
NSString *const kSallonResponseSaloonDstfrmCurrLocation = @"saloonDstfrmCurrLocation";
NSString *const kSallonResponseSaloonName = @"saloonName";
NSString *const kSallonResponseSaloonServices = @"saloonServices";
NSString *const kSallonResponseFaborateFlag = @"faborateFlag";
NSString *const kSallonResponseSaloonAddress = @"saloonAddress";


@interface SallonResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SallonResponse

@synthesize saloonRating = _saloonRating;
@synthesize saloonContact = _saloonContact;
@synthesize services = _services;
@synthesize saloonId = _saloonId;
@synthesize sallonReviewCount = _sallonReviewCount;
@synthesize saloonDstfrmCurrLocation = _saloonDstfrmCurrLocation;
@synthesize saloonName = _saloonName;
@synthesize saloonServices = _saloonServices;
@synthesize faborateFlag = _faborateFlag;
@synthesize saloonAddress = _saloonAddress;


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
            self.saloonRating = [self objectOrNilForKey:kSallonResponseSaloonRating fromDictionary:dict];
            self.saloonContact = [self objectOrNilForKey:kSallonResponseSaloonContact fromDictionary:dict];
    NSObject *receivedServices = [dict objectForKey:kSallonResponseServices];
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
            self.saloonId = [[self objectOrNilForKey:kSallonResponseSaloonId fromDictionary:dict] doubleValue];
            self.sallonReviewCount = [[self objectOrNilForKey:kSallonResponseSallonReviewCount fromDictionary:dict] doubleValue];
            self.saloonDstfrmCurrLocation = [self objectOrNilForKey:kSallonResponseSaloonDstfrmCurrLocation fromDictionary:dict];
            self.saloonName = [self objectOrNilForKey:kSallonResponseSaloonName fromDictionary:dict];
            self.saloonServices = [self objectOrNilForKey:kSallonResponseSaloonServices fromDictionary:dict];
            self.faborateFlag = [self objectOrNilForKey:kSallonResponseFaborateFlag fromDictionary:dict];
            self.saloonAddress = [self objectOrNilForKey:kSallonResponseSaloonAddress fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.saloonRating forKey:kSallonResponseSaloonRating];
    [mutableDict setValue:self.saloonContact forKey:kSallonResponseSaloonContact];
    NSMutableArray *tempArrayForServices = [NSMutableArray array];
    for (NSObject *subArrayObject in self.services) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForServices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForServices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForServices] forKey:kSallonResponseServices];
    [mutableDict setValue:[NSNumber numberWithDouble:self.saloonId] forKey:kSallonResponseSaloonId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sallonReviewCount] forKey:kSallonResponseSallonReviewCount];
    [mutableDict setValue:self.saloonDstfrmCurrLocation forKey:kSallonResponseSaloonDstfrmCurrLocation];
    [mutableDict setValue:self.saloonName forKey:kSallonResponseSaloonName];
    [mutableDict setValue:self.saloonServices forKey:kSallonResponseSaloonServices];
    [mutableDict setValue:self.faborateFlag forKey:kSallonResponseFaborateFlag];
    [mutableDict setValue:self.saloonAddress forKey:kSallonResponseSaloonAddress];

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

    self.saloonRating = [aDecoder decodeObjectForKey:kSallonResponseSaloonRating];
    self.saloonContact = [aDecoder decodeObjectForKey:kSallonResponseSaloonContact];
    self.services = [aDecoder decodeObjectForKey:kSallonResponseServices];
    self.saloonId = [aDecoder decodeDoubleForKey:kSallonResponseSaloonId];
    self.sallonReviewCount = [aDecoder decodeDoubleForKey:kSallonResponseSallonReviewCount];
    self.saloonDstfrmCurrLocation = [aDecoder decodeObjectForKey:kSallonResponseSaloonDstfrmCurrLocation];
    self.saloonName = [aDecoder decodeObjectForKey:kSallonResponseSaloonName];
    self.saloonServices = [aDecoder decodeObjectForKey:kSallonResponseSaloonServices];
    self.faborateFlag = [aDecoder decodeObjectForKey:kSallonResponseFaborateFlag];
    self.saloonAddress = [aDecoder decodeObjectForKey:kSallonResponseSaloonAddress];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_saloonRating forKey:kSallonResponseSaloonRating];
    [aCoder encodeObject:_saloonContact forKey:kSallonResponseSaloonContact];
    [aCoder encodeObject:_services forKey:kSallonResponseServices];
    [aCoder encodeDouble:_saloonId forKey:kSallonResponseSaloonId];
    [aCoder encodeDouble:_sallonReviewCount forKey:kSallonResponseSallonReviewCount];
    [aCoder encodeObject:_saloonDstfrmCurrLocation forKey:kSallonResponseSaloonDstfrmCurrLocation];
    [aCoder encodeObject:_saloonName forKey:kSallonResponseSaloonName];
    [aCoder encodeObject:_saloonServices forKey:kSallonResponseSaloonServices];
    [aCoder encodeObject:_faborateFlag forKey:kSallonResponseFaborateFlag];
    [aCoder encodeObject:_saloonAddress forKey:kSallonResponseSaloonAddress];
}

- (id)copyWithZone:(NSZone *)zone
{
    SallonResponse *copy = [[SallonResponse alloc] init];
    
    if (copy) {

        copy.saloonRating = [self.saloonRating copyWithZone:zone];
        copy.saloonContact = [self.saloonContact copyWithZone:zone];
        copy.services = [self.services copyWithZone:zone];
        copy.saloonId = self.saloonId;
        copy.sallonReviewCount = self.sallonReviewCount;
        copy.saloonDstfrmCurrLocation = [self.saloonDstfrmCurrLocation copyWithZone:zone];
        copy.saloonName = [self.saloonName copyWithZone:zone];
        copy.saloonServices = [self.saloonServices copyWithZone:zone];
        copy.faborateFlag = [self.faborateFlag copyWithZone:zone];
        copy.saloonAddress = [self.saloonAddress copyWithZone:zone];
    }
    
    return copy;
}


@end
