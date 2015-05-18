//
//  Object.m
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Profile.h"
#import "FabStylist.h"


NSString *const kObjectFabStylist = @"fabStylist";
NSString *const kObjectUserId = @"userId";
NSString *const kObjectMobileNo = @"mobileNo";
NSString *const kObjectImageUrl = @"imageUrl";
NSString *const kObjectEmail = @"email";
NSString *const kObjectMyRatedSaloons = @"myRatedSaloons";
NSString *const kObjectName = @"name";


@interface Profile ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Profile

@synthesize fabStylist = _fabStylist;
@synthesize userId = _userId;
@synthesize mobileNo = _mobileNo;
@synthesize imageUrl = _imageUrl;
@synthesize email = _email;
@synthesize myRatedSaloons = _myRatedSaloons;
@synthesize name = _name;


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
    NSObject *receivedFabStylist = [dict objectForKey:kObjectFabStylist];
    NSMutableArray *parsedFabStylist = [NSMutableArray array];
    if ([receivedFabStylist isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedFabStylist) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedFabStylist addObject:[FabStylist modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedFabStylist isKindOfClass:[NSDictionary class]]) {
       [parsedFabStylist addObject:[FabStylist modelObjectWithDictionary:(NSDictionary *)receivedFabStylist]];
    }

        self.fabStylist = [NSArray arrayWithArray:parsedFabStylist];
            self.userId = [[self objectOrNilForKey:kObjectUserId fromDictionary:dict] doubleValue];
            self.mobileNo = [self objectOrNilForKey:kObjectMobileNo fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kObjectImageUrl fromDictionary:dict];
            self.email = [self objectOrNilForKey:kObjectEmail fromDictionary:dict];
            self.myRatedSaloons = [self objectOrNilForKey:kObjectMyRatedSaloons fromDictionary:dict];
            self.name = [self objectOrNilForKey:kObjectName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForFabStylist = [NSMutableArray array];
    for (NSObject *subArrayObject in self.fabStylist) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFabStylist addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFabStylist addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFabStylist] forKey:kObjectFabStylist];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userId] forKey:kObjectUserId];
    [mutableDict setValue:self.mobileNo forKey:kObjectMobileNo];
    [mutableDict setValue:self.imageUrl forKey:kObjectImageUrl];
    [mutableDict setValue:self.email forKey:kObjectEmail];
    NSMutableArray *tempArrayForMyRatedSaloons = [NSMutableArray array];
    for (NSObject *subArrayObject in self.myRatedSaloons) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMyRatedSaloons addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMyRatedSaloons addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMyRatedSaloons] forKey:kObjectMyRatedSaloons];
    [mutableDict setValue:self.name forKey:kObjectName];

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

    self.fabStylist = [aDecoder decodeObjectForKey:kObjectFabStylist];
    self.userId = [aDecoder decodeDoubleForKey:kObjectUserId];
    self.mobileNo = [aDecoder decodeObjectForKey:kObjectMobileNo];
    self.imageUrl = [aDecoder decodeObjectForKey:kObjectImageUrl];
    self.email = [aDecoder decodeObjectForKey:kObjectEmail];
    self.myRatedSaloons = [aDecoder decodeObjectForKey:kObjectMyRatedSaloons];
    self.name = [aDecoder decodeObjectForKey:kObjectName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_fabStylist forKey:kObjectFabStylist];
    [aCoder encodeDouble:_userId forKey:kObjectUserId];
    [aCoder encodeObject:_mobileNo forKey:kObjectMobileNo];
    [aCoder encodeObject:_imageUrl forKey:kObjectImageUrl];
    [aCoder encodeObject:_email forKey:kObjectEmail];
    [aCoder encodeObject:_myRatedSaloons forKey:kObjectMyRatedSaloons];
    [aCoder encodeObject:_name forKey:kObjectName];
}

- (id)copyWithZone:(NSZone *)zone
{
    Profile *copy = [[Profile alloc] init];
    
    if (copy) {

        copy.fabStylist = [self.fabStylist copyWithZone:zone];
        copy.userId = self.userId;
        copy.mobileNo = [self.mobileNo copyWithZone:zone];
        copy.imageUrl = [self.imageUrl copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.myRatedSaloons = [self.myRatedSaloons copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
