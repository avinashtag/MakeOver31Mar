//
//  UIAlertView+MOAlertView.h
//  MakeOver
//
//  Created by Ekta on 04/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MOAlertCompletion)(NSInteger index);


@interface UIAlertView (MOAlertView)


@property(nonatomic, strong)MOAlertCompletion moAlertCompletion;

-(void)initWithTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertViewStyle)style completionHandler:(MOAlertCompletion)completionHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
