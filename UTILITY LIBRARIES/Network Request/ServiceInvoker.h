//
//  ServiceInvoker.h
//  AliveAirtel
//
//  Created by Anand on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configration.h"
#import "UtilityClass.h"
#import "ASIFormDataRequest.h"
#import "City.h"
#import <CoreLocation/CoreLocation.h>

@protocol ServiceInvokerDelegate <NSObject,CLLocationManagerDelegate>

@optional

//===============================================================================
//                   Get Task Details Delegates
//===============================================================================
-(void)serviceInvokerRequestFinished:(ASIHTTPRequest*)request;
-(void)serviceInvokerRequestFailed:(ASIHTTPRequest*)request;
//===============================================================================

@end

typedef enum {
    
    sirSuccess=0,
    sirFailed ,
}ServiceInvokerRequestResult;

typedef void(^ServiceInvokerCompletion)(ASIHTTPRequest *request, ServiceInvokerRequestResult result);

@interface ServiceInvoker : NSObject {
    
}

@property(unsafe_unretained,nonatomic) id<ServiceInvokerDelegate> __unsafe_unretained delegate;
@property(strong,nonatomic) __block NSMutableArray *cities;
@property(strong,nonatomic) __block City *city;
@property(assign,nonatomic) CLLocationCoordinate2D coordinate;
@property(strong,nonatomic)CLLocationManager *locationManager;
+ (ServiceInvoker*)sharedInstance; // To get instance of service invoker Singleton class
-(void)currentLocation;

#pragma mark- API service calling Methods


-(void)serviceInvokeWithParameters:(NSDictionary*)postParams requestAPI:(NSString*)stringURL spinningMessage:(NSString*)messageSpin completion:(ServiceInvokerCompletion)serviceInvokerCompletion;

- (void)makeApiRequestWithParams:(NSDictionary*)postParams requestAPI:(NSString*)stringURL reqTag:(NSInteger)tag delegate:(id<ServiceInvokerDelegate>)delegate;





@end
