//
//  DropDownListPassValueDelegate.h
//  MakeOver
//
//  Created by Himanshu Yadav on 14/04/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownListPassValueDelegate;

@protocol DropDownListPassValueDelegate <NSObject>

-(void)firstRowSelectedWithValue:(NSString*)value;
-(void)didSelectRowWithObject:(id)object;

@end