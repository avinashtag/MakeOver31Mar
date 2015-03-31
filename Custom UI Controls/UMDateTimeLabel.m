/*
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "UMDateTimeLabel.h"

@interface UMDateTimeLabel(Private) 


@end

@implementation UMDateTimeLabel

@synthesize timer, dateFormatter, format = _format, date = _date;

+ (id) dynamicLabelWithFormat: (NSString*) format {
    return [UMDateTimeLabel dynamicLabelWithFormat:format updateInterval:1.0];
}

+ (id) dynamicLabelWithFormat: (NSString*) format updateInterval:(NSTimeInterval) updateInterval {
    UMDateTimeLabel* label = [[self alloc] initDynamicWithFormat:format updateInterval:updateInterval];
#if ! __has_feature(objc_arc)
    return [label autorelease];
#else
    return label;
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
    return [UMDateTimeLabel staticLabelWithFormat:format date:[NSDate date]];
}

+ (id) staticLabelWithFormat: (NSString*) format date:(NSDate*) date {
    UMDateTimeLabel* label = [[self alloc] initStaticWithFormat:format date:date];
#if ! __has_feature(objc_arc)
    return [label autorelease];
#else
    return label;
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
    self.text = [self.dateFormatter stringFromDate:d];   
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
