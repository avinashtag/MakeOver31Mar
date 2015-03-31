//
//  NSString+MakeString.m
//  MakeOver
//
//  Created by Avinash Tag on 26/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "NSString+MakeString.h"

@implementation NSString (MakeString)


-(NSDate *)dateWithFormater:(NSString*)format{

    NSDateFormatter *formator = [[NSDateFormatter alloc]init];
    [formator setDateFormat:format];
    
    return [formator dateFromString:self];
}



@end
