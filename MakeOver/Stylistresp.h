//
//  Stylistresp.h
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Stylistresp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *stylistName;
@property (nonatomic, strong) NSString *stylishPosition;
@property (nonatomic, assign) double stylishId;
@property (nonatomic, strong) NSString *styListImgUrl;
@property (nonatomic, assign) double stylistFabCount;
@property (nonatomic, strong) NSString *faborateFlag;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
