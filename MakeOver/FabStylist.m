//
//  FabStylist.m
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FabStylist.h"
#import "SallonResponse.h"


NSString *const kFabStylistStylistMobile = @"stylistMobile";
NSString *const kFabStylistSallonResponse = @"sallonResponse";
NSString *const kFabStylistStylistName = @"stylistName";
NSString *const kFabStylistCreatedDate = @"createdDate";
NSString *const kFabStylistStylistId = @"stylistId";
NSString *const kFabStylistRating = @"rating";
NSString *const kFabStylistImageUrl = @"imageUrl";
NSString *const kFabStylistServices = @"services";
NSString *const kFabStylistStylishPosition = @"stylishPosition";


@interface FabStylist ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FabStylist

@synthesize stylistMobile = _stylistMobile;
@synthesize sallonResponse = _sallonResponse;
@synthesize stylistName = _stylistName;
@synthesize createdDate = _createdDate;
@synthesize stylistId = _stylistId;
@synthesize rating = _rating;
@synthesize imageUrl = _imageUrl;
@synthesize services = _services;
@synthesize stylishPosition = _stylishPosition;


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
            self.stylistMobile = [self objectOrNilForKey:kFabStylistStylistMobile fromDictionary:dict];
            self.sallonResponse = [SallonResponse modelObjectWithDictionary:[dict objectForKey:kFabStylistSallonResponse]];
            self.stylistName = [self objectOrNilForKey:kFabStylistStylistName fromDictionary:dict];
            self.createdDate = [self objectOrNilForKey:kFabStylistCreatedDate fromDictionary:dict];
            self.stylistId = [[self objectOrNilForKey:kFabStylistStylistId fromDictionary:dict] doubleValue];
            self.rating = [self objectOrNilForKey:kFabStylistRating fromDictionary:dict];
            self.imageUrl = [self objectOrNilForKey:kFabStylistImageUrl fromDictionary:dict];
            self.services = [self objectOrNilForKey:kFabStylistServices fromDictionary:dict];
            self.stylishPosition = [self objectOrNilForKey:kFabStylistStylishPosition fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stylistMobile forKey:kFabStylistStylistMobile];
    [mutableDict setValue:[self.sallonResponse dictionaryRepresentation] forKey:kFabStylistSallonResponse];
    [mutableDict setValue:self.stylistName forKey:kFabStylistStylistName];
    [mutableDict setValue:self.createdDate forKey:kFabStylistCreatedDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stylistId] forKey:kFabStylistStylistId];
    [mutableDict setValue:self.rating forKey:kFabStylistRating];
    [mutableDict setValue:self.imageUrl forKey:kFabStylistImageUrl];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForServices] forKey:kFabStylistServices];
    [mutableDict setValue:self.stylishPosition forKey:kFabStylistStylishPosition];

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

    self.stylistMobile = [aDecoder decodeObjectForKey:kFabStylistStylistMobile];
    self.sallonResponse = [aDecoder decodeObjectForKey:kFabStylistSallonResponse];
    self.stylistName = [aDecoder decodeObjectForKey:kFabStylistStylistName];
    self.createdDate = [aDecoder decodeObjectForKey:kFabStylistCreatedDate];
    self.stylistId = [aDecoder decodeDoubleForKey:kFabStylistStylistId];
    self.rating = [aDecoder decodeObjectForKey:kFabStylistRating];
    self.imageUrl = [aDecoder decodeObjectForKey:kFabStylistImageUrl];
    self.services = [aDecoder decodeObjectForKey:kFabStylistServices];
    self.stylishPosition = [aDecoder decodeObjectForKey:kFabStylistStylishPosition];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stylistMobile forKey:kFabStylistStylistMobile];
    [aCoder encodeObject:_sallonResponse forKey:kFabStylistSallonResponse];
    [aCoder encodeObject:_stylistName forKey:kFabStylistStylistName];
    [aCoder encodeObject:_createdDate forKey:kFabStylistCreatedDate];
    [aCoder encodeDouble:_stylistId forKey:kFabStylistStylistId];
    [aCoder encodeObject:_rating forKey:kFabStylistRating];
    [aCoder encodeObject:_imageUrl forKey:kFabStylistImageUrl];
    [aCoder encodeObject:_services forKey:kFabStylistServices];
    [aCoder encodeObject:_stylishPosition forKey:kFabStylistStylishPosition];
}

- (id)copyWithZone:(NSZone *)zone
{
    FabStylist *copy = [[FabStylist alloc] init];
    
    if (copy) {

        copy.stylistMobile = [self.stylistMobile copyWithZone:zone];
        copy.sallonResponse = [self.sallonResponse copyWithZone:zone];
        copy.stylistName = [self.stylistName copyWithZone:zone];
        copy.createdDate = [self.createdDate copyWithZone:zone];
        copy.stylistId = self.stylistId;
        copy.rating = [self.rating copyWithZone:zone];
        copy.imageUrl = [self.imageUrl copyWithZone:zone];
        copy.services = [self.services copyWithZone:zone];
        copy.stylishPosition = [self.stylishPosition copyWithZone:zone];
    }
    
    return copy;
}


@end
