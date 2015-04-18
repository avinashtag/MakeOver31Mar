//
//  MOTabBar.h
//  MakeOver
//
//  Created by Avinash Tag on 18/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOTabBar : UITabBarController <UITabBarControllerDelegate, UITabBarControllerDelegate> {
    
    BOOL isSelectedIndex2;
}


-(UIViewController*) viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

-(void)profiletab:(id)sender;

@end
