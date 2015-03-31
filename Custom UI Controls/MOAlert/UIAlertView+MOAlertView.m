//
//  UIAlertView+MOAlertView.m
//  MakeOver
//
//  Created by Ekta on 04/03/15.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "UIAlertView+MOAlertView.h"

@implementation UIAlertView (MOAlertView)


-(void)initWithTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertViewStyle)style completionHandler:(MOAlertCompletion)completionHandler cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self.moAlertCompletion = completionHandler;
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alertView setAlertViewStyle:style];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.moAlertCompletion!=nil) {
        self.moAlertCompletion(buttonIndex);
    }
}

@end
