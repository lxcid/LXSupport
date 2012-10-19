//
//  NSDate+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 30/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LXSupport)

- (NSDate *)dateAtEndOfDayWithCalendar:(NSCalendar *)theCalendar;
- (NSDate *)dateAtEndOfDay;
- (NSString *)stringInRFC3339;

@end
