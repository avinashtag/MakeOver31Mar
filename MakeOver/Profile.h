//
//  Object.h
//
//  Created by chandan chouksey on 22/03/2015
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Profile : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *fabStylist;
@property (nonatomic, assign) double userId;
@property (nonatomic, strong) NSString *mobileNo;
@property (nonatomic, assign) id imageUrl;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSArray *myRatedSaloons;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
