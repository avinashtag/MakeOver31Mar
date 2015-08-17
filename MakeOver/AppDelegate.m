//
//  AppDelegate.m
//  MakeOver
//
//  Created by Avinash Tag on 16/02/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomSelection.h"
#import "ServiceInvoker.h"
#import "LandingViewController.h"
#import "UtilityClass.h"


NSString *const k_sortByFavouriteStylist = @"sortByFavouriteStylist";
NSString *const k_sortByDistance = @"sortByDistance";
NSString *const k_sortByRating = @"sortByRating";
NSString *const k_filterBySex = @"filterBySex";
NSString *const k_filterByTime = @"filterByTime";
NSString *const k_filterByRange = @"filterByRange";
NSString *const k_filterByCardSupport = @"filterByCardPresent";

NSString *const k_isSorting = @"isSorting";
NSString *const k_isFiltering = @"isFiltering";
NSString *const k_isFilterChanged = @"isFilterChanged";


@interface AppDelegate (){
    WYPopoverController *popoverController;
    CustomSelection *customSelection;
}

@end

NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

@implementation AppDelegate

AppDelegate* appdelegate(){
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [AppDelegate resetSortNfilter];
    [ServiceInvoker sharedInstance];

    return YES;
}

+ (void)resetSortNfilter {
    
    NSMutableDictionary *dict_filterSortingParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"NO",k_sortByFavouriteStylist,@"",k_sortByDistance,@"",k_sortByRating,@"",k_filterBySex,@"",k_filterByTime,@"",k_filterByRange,@"NO",k_filterByCardSupport,@"YES",k_isSorting,@"NO",k_isFiltering,@"NO",k_isFilterChanged, nil];
    
    [dict_filterSortingParams setObject:@"0" forKey:@"filterByRange_lower"];
    [dict_filterSortingParams setObject:@"0" forKey:@"filterByRange_upper"];
    
    [UtilityClass SaveDatatoUserDefault:dict_filterSortingParams :@"sortNfilter"];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (IBAction)selectCityActionWithController:(id)controller popverFroomRect:(CGRect)frame CompletionHandler:(SelectCityCompletion)block {
  
    
    UIViewController *temp = (UIViewController*)controller;
    customSelection = [[controller storyboard] instantiateViewControllerWithIdentifier:@"CustomSelection"];
    customSelection.names = [[ServiceInvoker sharedInstance].cities valueForKeyPath:@"cityName"];
    
    [customSelection didSelectedWithComnpletion:^(NSString *name, NSIndexPath *indexPath) {
        [ServiceInvoker sharedInstance].city = [ServiceInvoker sharedInstance].cities[indexPath.row];
        [popoverController dismissPopoverAnimated:YES];
        block(name,indexPath);
    }];
    frame.origin.y = frame.origin.y+20;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:customSelection];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:frame inView:temp.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFadeWithScale completion:^{
        
    }];
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}




#pragma mark - FB SDK delegates

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            if (!error)
            {
                // We have a valid session
                //nslog(@"User session found");
            }
            break;

        case FBSessionStateClosed:

        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;

        default:
            break;
    }

    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}



@end
