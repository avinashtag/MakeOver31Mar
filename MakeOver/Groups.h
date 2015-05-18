//
//  Groups.h
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Groups : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *positionName;
@property (nonatomic, strong) NSMutableArray *stylistresp;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
