//
//  ServiceInvoker.m
//  AliveAirtel
//
//  Created by Bhupendra on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ServiceInvoker.h"
#import "City.h"
#import "DataModels.h"

#import "INTULocationManager.h"


@implementation ServiceInvoker

@synthesize delegate = _delegate;
@synthesize cities = _cities;

#pragma mark - Singleton Class Method
 
+ (ServiceInvoker*)sharedInstance {
    
	static ServiceInvoker *instance = nil;
	
	@synchronized(self) {
		if(instance == nil) {
			instance = [[self alloc] init];
            instance.cities = [[NSMutableArray alloc] init];
            [instance startSingleLocationRequest];
		}
	}
    if (!instance.cities.count) {
        [instance serviceInvokeWithParameters:nil requestAPI:API_GET_CITIES spinningMessage:nil completion:^(ASIHTTPRequest *request, ServiceInvokerRequestResult result) {
            if (result == sirSuccess) {
                NSError *error = nil;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:&error];
                
                instance.cities = [[City initializeWithResponse:responseDict] mutableCopy];
                instance.city = instance.cities.count ? instance.cities[0] : nil;
            }
        }];

    }
    
	return(instance);
}

- (void)cancelOperationFromQueue {
    
    if (opQueue) {
        isOperationCancelled = YES;
        [UtilityClass removeHudFromView:nil afterDelay:0];

        [opQueue cancelAllOperations];
    }
}

- (void)setRequestTypeSearch {
    
    self.isSearchRequest = YES;
}


#pragma mark - API Request Methods

- (void)makeApiRequestWithParams:(NSDictionary*)postParams requestAPI:(NSString*)stringURL reqTag:(NSInteger)tag delegate:(id<ServiceInvokerDelegate>)delegate {
    
    self.delegate = delegate;
    
    if ([UtilityClass isNetworkAvailable])
    {
        // ********* Initialise Request ******** //
        
        NSURL *url = [NSURL URLWithString:[API_BASE_STRING stringByAppendingString:stringURL]];
        
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
        request.tag = tag;
        
        request.shouldAttemptPersistentConnection = NO;

        
        if (postParams != nil) {
            for (NSString *key in postParams) {
                [request addPostValue:[postParams objectForKey:key] forKey:key];
            }
        }
        
        __weak typeof(request) weakRequest = request;
        
        [request setCompletionBlock:^{
            
            __strong typeof(request) strongRequest = weakRequest;
            
            NSError *error = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:strongRequest.responseData options:NSJSONReadingMutableLeaves error:&error];
            
            switch(strongRequest.responseStatusCode)
            {
                case 200:
                {
                    if (error == nil && responseDict != nil)
                    {
                        if (([responseDict objectForKey:@"error"] != [NSNull null]) && ([[[responseDict objectForKey:@"error"] objectForKey:@"errorCode"] isEqualToString:@"0"]))
                        {
                            if([_delegate respondsToSelector:@selector(serviceInvokerRequestFinished:)]){
                                [_delegate performSelector:@selector(serviceInvokerRequestFinished:) withObject:strongRequest];
                            }
                        }
                        else {
                            
                            if([_delegate respondsToSelector:@selector(serviceInvokerRequestFailed:)]) {
                                [_delegate serviceInvokerRequestFailed:strongRequest];
                            }
                            
                            NSString *errorMessage = [[responseDict objectForKey:@"error"] objectForKey:@"errorMessage"];
                            if (errorMessage == [NSNull null])
                                [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                            else
                                [UtilityClass showAlertwithTitle:nil message:errorMessage];
                        }
                    }
                    else if (error != nil) {
                        NSLog(@"Error in JSON: %@",error.description);
                        [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                    }
                    else {
                        NSLog(@"Response is Nil");
                        [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                    }
                    
                    break;
                }
                    
                default:
                {
                    NSLog(@"failed: server error code: %i",strongRequest.responseStatusCode);
                    
                    if([_delegate respondsToSelector:@selector(serviceInvokerRequestFailed:)]) {
                        [_delegate serviceInvokerRequestFailed:strongRequest];
                    }
                    
                    [UtilityClass showAlertwithTitle:nil message:@"Something went wrong, please try again later."];

                    break;
                }
            }
            
            NSLog(@"API service Response: %@",strongRequest.responseString);
        }];
        
        
        [request setFailedBlock:^{
            
            __strong typeof(request) strongRequest = weakRequest;
            
            if([_delegate respondsToSelector:@selector(serviceInvokerRequestFailed:)]) {
                [_delegate serviceInvokerRequestFailed:strongRequest];
            }
            
            NSError *error = [strongRequest error];
            NSLog(@"error description: %@",error.description);
            
            [UtilityClass showAlertwithTitle:@"Error" message:@"Something went wrong, please try again later."];
        }];
        
        request.timeOutSeconds = TimeOut60;
        [request setShouldAttemptPersistentConnection:NO];
        [request startAsynchronous];

    }
    else { // Show alert for Data connectivity failure.
        [UtilityClass showAlertwithTitle:@"Network Connectivity Required!" message:@"Please check your network connection and try again."];
        if([_delegate respondsToSelector:@selector(serviceInvokerRequestFailed:)]) {
            [_delegate serviceInvokerRequestFailed:nil];
        }
    }

}


#pragma mark -
#pragma mark general request error handling
- (void)requestFailed:(ASIHTTPRequest*)request {
	
}



-(void)serviceInvokeWithParameters:(NSDictionary*)postParams requestAPI:(NSString*)stringURL spinningMessage:(NSString*)messageSpin completion:(ServiceInvokerCompletion)serviceInvokerCompletion{
        
    if ((messageSpin!=nil) && !self.isSearchRequest) {
        [UtilityClass showSpinnerWithMessage:messageSpin onView:nil];
    }
    
    if (![UtilityClass isNetworkAvailable]){
        [UtilityClass removeHudFromView:nil afterDelay:0.1];
        [UtilityClass showAlertwithTitle:@"Network Connectivity Required!" message:@"Please check your network connection and try again."];
        if (serviceInvokerCompletion!=nil) {
            serviceInvokerCompletion(nil, sirFailed);
        }
        return;
    }
    // ********* Initialise Request ******** //
    
    NSURL *url = [NSURL URLWithString:[API_BASE_STRING stringByAppendingString:stringURL]];
    NSLog(@"<URL>:\n\n<<<<<<%@\n<<<<<ARGS:%@\n\n",url,postParams);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];

    request.shouldAttemptPersistentConnection = NO;

    if (postParams != nil) {
        [postParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [request addPostValue:value forKey:key];
        }];
    }
    
    isOperationCancelled = NO;

    __weak typeof(request) weakRequest = request;

    [request setFailedBlock:^{
        
        if (self.isSearchRequest) {
            self.isSearchRequest = NO;
        }
        [UtilityClass removeHudFromView:nil afterDelay:0];

        __strong typeof(request) strongRequest = weakRequest;
       
        if (serviceInvokerCompletion!=nil) {
            serviceInvokerCompletion(strongRequest, sirFailed);
        }
        NSError *error = [strongRequest error];
        NSLog(@"error description: %@",error.description);
        
        if (!isOperationCancelled) {
            [UtilityClass showAlertwithTitle:@"Error" message:@"Something went wrong, please try again later."];
        }
    }];

    
    [request setCompletionBlock:^{
        
        if (self.isSearchRequest) {
            self.isSearchRequest = NO;
        }
        [UtilityClass removeHudFromView:nil afterDelay:0.1];

        __strong typeof(request) strongRequest = weakRequest;
        NSError *error = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:strongRequest.responseData options:NSJSONReadingMutableLeaves error:&error];
        
        switch(strongRequest.responseStatusCode)
        {
            case 200:
            {
                if (error == nil && responseDict != nil)
                {
                    if (([responseDict objectForKey:@"error"] != [NSNull null]) && ([[[responseDict objectForKey:@"error"] objectForKey:@"errorCode"] isEqualToString:@"0"]))
                    {
                        if (serviceInvokerCompletion!=nil) {
                            serviceInvokerCompletion(strongRequest, sirSuccess);
                        }
                    }
                    else {
                        
                        if (serviceInvokerCompletion!=nil) {
                            serviceInvokerCompletion(strongRequest, sirFailed);
                        }
                        NSString *errorMessage = [[responseDict objectForKey:@"error"] objectForKey:@"errorMessage"];
                        ((NSNull*)errorMessage == [NSNull null]) ? [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"] : [UtilityClass showAlertwithTitle:@"Error" message:errorMessage];
                    }
                }
                else
                    [UtilityClass showAlertwithTitle:nil message:@"No saloon found for the current location/category"];
                
                
                (error != nil) ? NSLog(@"Error in JSON: %@",error.description): NSLog(@"Response is Nil");
                break;
            }
                
            default: {
                NSLog(@"failed: server error code: %i",strongRequest.responseStatusCode);
                if (serviceInvokerCompletion!=nil) {
                    serviceInvokerCompletion(strongRequest, sirFailed);
                }
                
                [UtilityClass showAlertwithTitle:nil message:@"Something went wrong, please try again later."];

                break;
            }
        }
        
        NSLog(@"API service JSon Response: %@",strongRequest.responseString);
    }];
    
    
    
    request.timeOutSeconds = TimeOut60;
    [request setShouldAttemptPersistentConnection:NO];
//    [request startAsynchronous];
    if (!opQueue) {
        opQueue = [[NSOperationQueue alloc] init];
    }
    [opQueue addOperation:request]; //queue is an NSOperationQueue
}


/*
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    _coordinate = [[manager location] coordinate];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"error in fetching location %@",error.description);
    
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        switch ([error code]) {
                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
            case kCLErrorDenied:
                NSLog(@"fetching location denied by user");

                
            case kCLErrorLocationUnknown:
                
            default:
                break;
        }
    } else {
        // We handle all non-CoreLocation errors here
    }
}

-(void)currentLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    
    
    _coordinate = [[_locationManager location] coordinate];
    
}
 */

/**
 Starts a new one-time request for the current location.
 */
- (void)startSingleLocationRequest
{
//    __weak __typeof(self) weakSelf = self;
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                                                timeout:5
                                                   delayUntilAuthorized:YES
                                                                  block:
                              ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
//                                  __typeof(weakSelf) strongSelf = weakSelf;
                                  
                                  if (status == INTULocationStatusSuccess) {
                                      
                                      _coordinate = currentLocation.coordinate;
                                      // achievedAccuracy is at least the desired accuracy (potentially better)
                                    
                                  }
                                  else if (status == INTULocationStatusTimedOut) {
                                      // You may wish to inspect achievedAccuracy here to see if it is acceptable, if you plan to use currentLocation
                                      _coordinate = currentLocation.coordinate;

                                  }
                                  else {
                                      // An error occurred
                                      
                                  }
                                  
                              }];
}


@end
