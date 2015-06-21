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
            [instance currentLocation];
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


#pragma mark - API Request Methods

- (void)makeApiRequestWithParams:(NSDictionary*)postParams requestAPI:(NSString*)stringURL reqTag:(NSInteger)tag delegate:(id<ServiceInvokerDelegate>)delegate {
    
    self.delegate = delegate;
    
    if ([UtilityClass isNetworkAvailable])
    {
        // ********* Initialise Request ******** //
        
        NSURL *url = [NSURL URLWithString:[API_BASE_STRING stringByAppendingString:stringURL]];
        
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
        request.tag = tag;
        
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
                                [UtilityClass showAlertwithTitle:@"Error" message:@"No saloon found for the current location"];
                            else
                                [UtilityClass showAlertwithTitle:@"Error" message:errorMessage];
                        }
                    }
                    else if (error != nil) {
                        NSLog(@"Error in JSON: %@",error.description);
                        [UtilityClass showAlertwithTitle:@"Error" message:@"No saloon found for the current location"];
                    }
                    else {
                        NSLog(@"Response is Nil");
                        [UtilityClass showAlertwithTitle:@"Error" message:@"No saloon found for the current location"];
                    }
                    
                    break;
                }
                    
                default:
                {
                    NSLog(@"failed: server error code: %i",strongRequest.responseStatusCode);
                    
                    if([_delegate respondsToSelector:@selector(serviceInvokerRequestFailed:)]) {
                        [_delegate serviceInvokerRequestFailed:strongRequest];
                    }
                    
                    [UtilityClass showAlertwithTitle:@"Error" message:@"Something went wrong, please try again later."];

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
    
    if (messageSpin!=nil) {
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
    if (postParams != nil) {
        [postParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [request addPostValue:value forKey:key];
        }];
    }
    __weak typeof(request) weakRequest = request;

    [request setFailedBlock:^{
        [UtilityClass removeHudFromView:nil afterDelay:0.1];

        __strong typeof(request) strongRequest = weakRequest;
       
        if (serviceInvokerCompletion!=nil) {
            serviceInvokerCompletion(strongRequest, sirFailed);
        }
        NSError *error = [strongRequest error];
        NSLog(@"error description: %@",error.description);
        [UtilityClass showAlertwithTitle:@"Error" message:error.description];
    }];

    
    [request setCompletionBlock:^{
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
                        ((NSNull*)errorMessage == [NSNull null]) ? [UtilityClass showAlertwithTitle:@"Error" message:@"We've no data for the current locations"] : [UtilityClass showAlertwithTitle:@"Error" message:errorMessage];
                    }
                }
                (error != nil) ? NSLog(@"Error in JSON: %@",error.description): NSLog(@"Response is Nil");
                break;
            }
                
            default: {
                NSLog(@"failed: server error code: %i",strongRequest.responseStatusCode);
                if (serviceInvokerCompletion!=nil) {
                    serviceInvokerCompletion(strongRequest, sirFailed);
                }
                break;
            }
        }
        
        NSLog(@"API service Response: %@",strongRequest.responseString);
    }];
    
    
    
    request.timeOutSeconds = TimeOut60;
    [request setShouldAttemptPersistentConnection:NO];
    [request startAsynchronous];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    _coordinate = [[manager location] coordinate];
    
}

-(void)currentLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    
    
    _coordinate = [[_locationManager location] coordinate];
    
}
@end
