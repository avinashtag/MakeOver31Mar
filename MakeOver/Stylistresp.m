//
//  Stylistresp.m
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Stylistresp.h"


NSString *const kStylistrespStylistName = @"stylistName";
NSString *const kStylistrespStylishPosition = @"stylishPosition";
NSString *const kStylistrespStylishId = @"stylishId";
NSString *const kStylistrespStyListImgUrl = @"styListImgUrl";
NSString *const kStylistrespStylistFabCount = @"stylistFabCount";
NSString *const kStylistrespFaborateFlag = @"faborateFlag";


@interface Stylistresp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Stylistresp

@synthesize stylistName = _stylistName;
@synthesize stylishPosition = _stylishPosition;
@synthesize stylishId = _stylishId;
@synthesize styListImgUrl = _styListImgUrl;
@synthesize stylistFabCount = _stylistFabCount;
@synthesize faborateFlag = _faborateFlag;


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
            self.stylistName = [self objectOrNilForKey:kStylistrespStylistName fromDictionary:dict];
            self.stylishPosition = [self objectOrNilForKey:kStylistrespStylishPosition fromDictionary:dict];
            self.stylishId = [[self objectOrNilForKey:kStylistrespStylishId fromDictionary:dict] doubleValue];
            self.styListImgUrl = [self objectOrNilForKey:kStylistrespStyListImgUrl fromDictionary:dict];
            self.stylistFabCount = [[self objectOrNilForKey:kStylistrespStylistFabCount fromDictionary:dict] doubleValue];
            self.faborateFlag = [self objectOrNilForKey:kStylistrespFaborateFlag fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stylistName forKey:kStylistrespStylistName];
    [mutableDict setValue:self.stylishPosition forKey:kStylistrespStylishPosition];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stylishId] forKey:kStylistrespStylishId];
    [mutableDict setValue:self.styListImgUrl forKey:kStylistrespStyListImgUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.stylistFabCount] forKey:kStylistrespStylistFabCount];
    [mutableDict setValue:self.faborateFlag forKey:kStylistrespFaborateFlag];

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

    self.stylistName = [aDecoder decodeObjectForKey:kStylistrespStylistName];
    self.stylishPosition = [aDecoder decodeObjectForKey:kStylistrespStylishPosition];
    self.stylishId = [aDecoder decodeDoubleForKey:kStylistrespStylishId];
    self.styListImgUrl = [aDecoder decodeObjectForKey:kStylistrespStyListImgUrl];
    self.stylistFabCount = [aDecoder decodeDoubleForKey:kStylistrespStylistFabCount];
    self.faborateFlag = [aDecoder decodeObjectForKey:kStylistrespFaborateFlag];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stylistName forKey:kStylistrespStylistName];
    [aCoder encodeObject:_stylishPosition forKey:kStylistrespStylishPosition];
    [aCoder encodeDouble:_stylishId forKey:kStylistrespStylishId];
    [aCoder encodeObject:_styListImgUrl forKey:kStylistrespStyListImgUrl];
    [aCoder encodeDouble:_stylistFabCount forKey:kStylistrespStylistFabCount];
    [aCoder encodeObject:_faborateFlag forKey:kStylistrespFaborateFlag];
}

- (id)copyWithZone:(NSZone *)zone
{
    Stylistresp *copy = [[Stylistresp alloc] init];
    
    if (copy) {

        copy.stylistName = [self.stylistName copyWithZone:zone];
        copy.stylishPosition = [self.stylishPosition copyWithZone:zone];
        copy.stylishId = self.stylishId;
        copy.styListImgUrl = [self.styListImgUrl copyWithZone:zone];
        copy.stylistFabCount = self.stylistFabCount;
        copy.faborateFlag = [self.faborateFlag copyWithZone:zone];
    }
    
    return copy;
}


@end
