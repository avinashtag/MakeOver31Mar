//
//  SaloonReviewObject.m
//
//  Created by chandan chouksey on 26/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "SaloonReview.h"
#import "Configration.h"

NSString *const kSaloonReviewObjectUserImgUrl = @"userImgUrl";
NSString *const kSaloonReviewObjectUser = @"user";
NSString *const kSaloonReviewObjectReview = @"review";
NSString *const kSaloonReviewObjectSaloonId = @"saloonId";
NSString *const kSaloonReviewObjectReviewDate = @"reviewDate";
NSString *const kSaloonReviewObjectDateCreated = @"dateCreated";
NSString *const kSaloonReviewObjectRating = @"rating";


@interface SaloonReview ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SaloonReview

@synthesize userImgUrl = _userImgUrl;
@synthesize user = _user;
@synthesize review = _review;
@synthesize saloonId = _saloonId;
@synthesize reviewDate = _reviewDate;
@synthesize rating = _rating;


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
            self.userImgUrl = [self objectOrNilForKey:kSaloonReviewObjectUserImgUrl fromDictionary:dict];
            self.user = [self objectOrNilForKey:kSaloonReviewObjectUser fromDictionary:dict];
            self.review = [self objectOrNilForKey:kSaloonReviewObjectReview fromDictionary:dict];
            self.saloonId = [[self objectOrNilForKey:kSaloonReviewObjectSaloonId fromDictionary:dict] doubleValue];
            self.reviewDate = [self objectOrNilForKey:kSaloonReviewObjectReviewDate fromDictionary:dict];
            self.rating = [[self objectOrNilForKey:kSaloonReviewObjectRating fromDictionary:dict] doubleValue];
            self.dateCreated = [self.reviewDate dateWithFormater:@"dd-MM-yyyy"];
            self.reviewDate = [self.dateCreated stringWithFormator:@"'('dd MMM, yyyy')'"];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userImgUrl forKey:kSaloonReviewObjectUserImgUrl];
    [mutableDict setValue:self.user forKey:kSaloonReviewObjectUser];
    [mutableDict setValue:self.review forKey:kSaloonReviewObjectReview];
    [mutableDict setValue:[NSNumber numberWithDouble:self.saloonId] forKey:kSaloonReviewObjectSaloonId];
    [mutableDict setValue:self.reviewDate forKey:kSaloonReviewObjectReviewDate];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rating] forKey:kSaloonReviewObjectRating];
    [mutableDict setValue:self.dateCreated forKey:kSaloonReviewObjectDateCreated];

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

    self.userImgUrl = [aDecoder decodeObjectForKey:kSaloonReviewObjectUserImgUrl];
    self.user = [aDecoder decodeObjectForKey:kSaloonReviewObjectUser];
    self.review = [aDecoder decodeObjectForKey:kSaloonReviewObjectReview];
    self.saloonId = [aDecoder decodeDoubleForKey:kSaloonReviewObjectSaloonId];
    self.reviewDate = [aDecoder decodeObjectForKey:kSaloonReviewObjectReviewDate];
    self.dateCreated = [aDecoder decodeObjectForKey:kSaloonReviewObjectDateCreated];
    self.rating = [aDecoder decodeDoubleForKey:kSaloonReviewObjectRating];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userImgUrl forKey:kSaloonReviewObjectUserImgUrl];
    [aCoder encodeObject:_user forKey:kSaloonReviewObjectUser];
    [aCoder encodeObject:_review forKey:kSaloonReviewObjectReview];
    [aCoder encodeDouble:_saloonId forKey:kSaloonReviewObjectSaloonId];
    [aCoder encodeObject:_reviewDate forKey:kSaloonReviewObjectReviewDate];
    [aCoder encodeObject:_dateCreated forKey:kSaloonReviewObjectDateCreated] ;
    [aCoder encodeDouble:_rating forKey:kSaloonReviewObjectRating];
}

- (id)copyWithZone:(NSZone *)zone
{
    SaloonReview *copy = [[SaloonReview alloc] init];
    
    if (copy) {

        copy.userImgUrl = [self.userImgUrl copyWithZone:zone];
        copy.user = [self.user copyWithZone:zone];
        copy.review = [self.review copyWithZone:zone];
        copy.saloonId = self.saloonId;
        copy.reviewDate = [self.reviewDate copyWithZone:zone];
        copy.dateCreated = [self.dateCreated copyWithZone:zone];
        copy.rating = self.rating;
    }
    
    return copy;
}


@end
