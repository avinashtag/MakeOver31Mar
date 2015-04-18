//
//
  //  Configration.h
//  AirtelInvester
//
//  Created by bhupendra on 4/5/13.
//  Copyright (c) 2013 airtel. All rights reserved.
//

enum TimeConstants {
    TimeOut30 = 30,
    TimeOut60 = 60
    }TimeEnum;

// ********* Macros related to API services ******** //


#import "NSDate+MakeDate.h"
#import "NSString+MakeString.h"
#define API_BASE_STRING @"http://104.236.55.19:8181/MakeOver/rest/service/"


#define API_RegisterUser @"registerUser"

#define API_RegisterVerifyUser @"verifyUser"

#define API_GET_CITIES @"getCityList"

#define API_GET_SALOONS @"getSaloon"

#define API_SEARCH @"saloonSearch"

#define API_RATE_SALOON @"rateSaloon"

#define API_RATE_STYLISH @"rateStylish"

#define API_RATE_REVIEW @"rateAndReview"

#define API_GET_REVIEW_BY_SALOON @"getReviewBySaloon"

#define API_GET_STYLIST_REVIEW @"getStylistReview"

#define API_GET_Profile @"myProfile"

#define API_ADD_FAVOURITE @"addFaborate"

#define API_GET_TUTORIAL @"getTutorial"

#define API_GET_OFFER @"getOffer"

// ********* End of Macros related to API services ******** //



#define kTimeOutSeconds 30
