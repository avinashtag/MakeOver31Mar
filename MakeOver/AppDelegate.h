//
//  AppDelegate.h
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import <FacebookSDK/FacebookSDK.h>

typedef void(^SelectCityCompletion)(NSString *cityName, NSIndexPath *indexPath);

extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate,WYPopoverControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIView *topBarView;
@property (weak, nonatomic) UILabel *titleMO;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UIButton *selectCity;
@property (weak, nonatomic) IBOutlet  UINavigationController *navConCenterTab;

AppDelegate* appdelegate();
- (IBAction)selectCityActionWithController:(id)controller popverFroomRect:(CGRect)frame CompletionHandler:(SelectCityCompletion)block ;


@end

