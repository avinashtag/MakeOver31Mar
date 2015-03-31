//
//  NSObject+MOObject.m
//  MakeOver
//
//  Created by Avinash Tag on 18/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "NSObject+MOObject.h"

@implementation NSObject (MOObject)



id nullRemover(id variable){
    if ((NSNull*)variable == [NSNull null]) {
        return @"";
    }
    else
        return variable;
 
}
@end
