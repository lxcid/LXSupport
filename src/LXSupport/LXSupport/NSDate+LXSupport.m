//
//  NSDate+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 30/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSDate+LXSupport.h"

@implementation NSDate (LXSupport)

- (NSDate *)dateAtEndOfDayWithCalendar:(NSCalendar *)theCalendar {
    NSDateComponents *theDateComponents = [theCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    theDateComponents.hour = 23;
    theDateComponents.minute = 59;
    theDateComponents.second = 59;
    return [theCalendar dateFromComponents:theDateComponents];
}

- (NSDate *)dateAtEndOfDay {
    return [self dateAtEndOfDayWithCalendar:[NSCalendar currentCalendar]];
}

- (NSString *)stringInRFC3339 {
    NSDateFormatter *theDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    theDateFormatter.locale = theLocale;
    theDateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ";
    return [theDateFormatter stringFromDate:self];
}

@end
