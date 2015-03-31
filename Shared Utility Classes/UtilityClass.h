//
//  UtilityClass.h
//  SelfCare
//
//  Created by Agile on 7/25/13.
//  Copyright (c) 2013 Bharti Airtel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@class Encription;
@interface UtilityClass : NSObject
{

}

+(BOOL)isNetworkAvailable;
+(void)updateNetworkStatus:(BOOL)status;
+(BOOL)isNetworkConnected;

//spinner methods
+ (void)showSpinnerWithMessage:(NSString*)message onView:(UIView*)controllerView ;
+ (void)removeHudFromView:(UIView*)controllerView afterDelay:(NSTimeInterval)delay ;
+(CGSize)currentScreenBoundsSize;
+(UILabel *)setLabelUnderline:(UILabel *)label;
+(UILabel *)setLabelFont:(UILabel *)label size:(CGFloat)size_t;
+(NSString*)getCurrentTimeStamp;
+(NSString*)getSalt;

// NSUserdefaults Operations
+(id)RetrieveDataFromUserDefault:(NSString*)key;
+(void)SaveDatatoUserDefault:(id)Data :(NSString*)key;
// *******

+(void)showAlertwithTitle:(NSString*)Title message:(NSString*)Message;
+(void)showAlertwithTitle:(NSString*)Title message:(NSString*)Message delgate:(id)delegate;

+ (NSString*)getDeviceIdentifier;
//+(NSMutableDictionary*)getEncriptedToken;
//+(NSMutableDictionary*)getEncriptedTokenWithTimeStamp:(NSString*)timeStamp;
+(void)logout;
+(void)loadHomePage:(UIViewController*)viewController;
+(void)loadSelectAccountPage:(UIViewController*)viewController;

+(NSString*)getDocumentDirectoryPath;
+(void)CopyOrreplaceDirectoryAtDocumentFolder:(NSString*)directory;
+(NSString*)getDocumentDirectoryPath:(NSString*)path;


@end
