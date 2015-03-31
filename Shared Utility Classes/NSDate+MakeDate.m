//
//  NSDate+MakeDate.m
//  MakeOver
//
//  Created by Avinash Tag on 26/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "NSDate+MakeDate.h"

@implementation NSDate (MakeDate)


-(NSString *)stringWithFormator:(NSString*)format{
    
    NSDateFormatter *formator = [[NSDateFormatter alloc]init];
    [formator setDateFormat:format];
    
    return [formator stringFromDate:self];
}
@end
