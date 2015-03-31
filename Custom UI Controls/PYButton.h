//
//  PYButton.h
//  MakeOver
//
//  Created by Avinash Tag on 27/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYButton : UIButton



@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;
@property (nonatomic, strong) NSDate* date;

// the format that will be used by `updateTime`, changes to this field while displaying the label will be picked up
@property (nonatomic, copy) NSString* format;

/*
 * Creates a label with the given format that is updated once per second
 */
+ (id) dynamicLabelWithFormat: (NSString*) format;

/*
 * Creates a label with the given format and update interval
 */
+ (id) dynamicLabelWithFormat: (NSString*) format updateInterval:(NSTimeInterval) updateInterval;

/*
 * Creates a label with the given format and current time, the label won't get updated
 */
+ (id) staticLabelWithFormat: (NSString*) format;

/*
 * Creates a label with the given format and date, the label won't get updated
 */
+ (id) staticLabelWithFormat: (NSString*) format date:(NSDate*) date;

/*
 * Creates a label with the given format and update interval
 */
- (id) initDynamicWithFormat: (NSString*) format updateInterval:(NSTimeInterval) updateInterval;

/*
 * Creates a label with the given format and date, the label won't get updated
 */
- (id) initStaticWithFormat: (NSString*) format date: (NSDate*) date;

// will be automatically called by the scheduled timer
- (void) updateText;

// will be automatically called upon creation, only call when you stopped the timer beforehand
- (void) startTimerWithTimeInterval: (NSTimeInterval) timeInterval;

// stops the current timer
- (void) stopTimer;

@end
