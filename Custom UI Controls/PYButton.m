//
//  PYButton.m
//  MakeOver
//
//  Created by Avinash Tag on 27/03/2015.
//  Copyright (c) 2015 Avinash Tag. All rights reserved.
//

#import "PYButton.h"

@implementation PYButton

@synthesize timer, dateFormatter, format = _format, date = _date;

+ (id) dynamicLabelWithFormat: (NSString*) format {
    return [PYButton dynamicLabelWithFormat:format updateInterval:1.0];
}

+ (id) dynamicLabelWithFormat: (NSString*) format updateInterval:(NSTimeInterval) updateInterval {
    PYButton* button = [[self alloc] initDynamicWithFormat:format updateInterval:updateInterval];
#if ! __has_feature(objc_arc)
    return [button autorelease];
#else
    return button;
#endif
    
}

#pragma mark- Pankaj's Implementation

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        self.format = @"hh:mm";
        
        self.dateFormatter = [NSDateFormatter new];
        
        [self updateText];
        
        [self startTimerWithTimeInterval:1.0];
    }
    
    return(self);
}



#pragma mark-
- (id) initDynamicWithFormat: (NSString*) format updateInterval:(NSTimeInterval) updateInterval {
    self = [super init];
    if (self != nil) {
        self.format = format;
        
        self.dateFormatter = [NSDateFormatter new];
        
        [self updateText];
        
        [self startTimerWithTimeInterval:updateInterval];
        
#if ! __has_feature(objc_arc)
        [self.dateFormatter release];
#endif
    }
    return self;
}

+ (id) staticLabelWithFormat: (NSString*) format {
    return [PYButton staticLabelWithFormat:format date:[NSDate date]];
}

+ (id) staticLabelWithFormat: (NSString*) format date:(NSDate*) date {
    PYButton* button = [[self alloc] initStaticWithFormat:format date:date];
#if ! __has_feature(objc_arc)
    return [button autorelease];
#else
    return button;
#endif
}

- (id) initStaticWithFormat: (NSString*) format date: (NSDate*) date {
    self = [super init];
    if (self != nil) {
        self.format = format;
        self.date = date;
        self.dateFormatter = [NSDateFormatter new];
        
        [self updateText];
        
#if ! __has_feature(objc_arc)
        [self.dateFormatter release];
#endif
        
    }
    return self;
}

- (void) updateText {
    NSDate* d = self.date;
    
    // use the current time if no date is specified
    if (d == nil) {
        d = [NSDate date];
    }
    [self.dateFormatter setDateFormat:self.format];
    [self setTitle:[self.dateFormatter stringFromDate:d] forState:UIControlStateNormal] ;
}

- (void) startTimerWithTimeInterval: (NSTimeInterval) timeInterval {
    if (self.timer != nil) {
        [self stopTimer];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateText) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void) willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        [self stopTimer];
    }
}

- (void) dealloc {
#if ! __has_feature(objc_arc)
    self.timer = nil;
    self.format = nil;
    self.dateFormatter = nil;
    [super dealloc];
#endif
}

@end
