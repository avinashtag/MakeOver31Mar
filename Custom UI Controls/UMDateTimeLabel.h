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

#import <UIKit/UIKit.h>

@interface UMDateTimeLabel : UILabel


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
