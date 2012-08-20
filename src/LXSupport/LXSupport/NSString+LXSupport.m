//
//  NSString+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 30/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSString+LXSupport.h"

@implementation NSString (LXSupport)

+ (NSString *)stringByRandomlyGeneratedFromAlphanumericSetWithLength:(NSUInteger)theLength {
    static uint8_t const theAlphanumericTable[62] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    size_t theAlphanumericTableLength = sizeof(theAlphanumericTable) / sizeof(*theAlphanumericTable);
    NSMutableData *theRandomStringData = [NSMutableData dataWithLength:theLength];
    uint8_t *theOutput = (uint8_t *)theRandomStringData.mutableBytes;
    for (NSUInteger theIndex = 0; theIndex < theLength; theIndex++) {
        theOutput[theIndex] = theAlphanumericTable[arc4random_uniform(theAlphanumericTableLength)];
    }
    return [[NSString alloc] initWithData:theRandomStringData encoding:NSASCIIStringEncoding];
}


- (NSDate *)dateInRFC3339 {
    NSDateFormatter *theDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    theDateFormatter.locale = theLocale;
    NSDate *theDate = nil;
    NSError *theError = nil;
    // 2012-07-30T04:13:28Z
    theDateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z";
    if ([theDateFormatter getObjectValue:&theDate forString:self range:nil error:&theError]) {
        return theDate;
    } else {
        NSLog(@"Date '%@' could not be parsed with RFC 3339 format: %@", self, theError);
        return nil;
    }
}

- (NSDate *)dateInRFC2822 {
    NSDateFormatter *theDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    theDateFormatter.locale = theLocale;
    NSDate *theDate = nil;
    NSError *theError = nil;
    // Mon, 30 Jul 2012 04:13:28 GMT
    theDateFormatter.dateFormat = @"EEE', 'dd' 'MMM' 'yyyy' 'HH':'mm':'ss' 'Z";
    if ([theDateFormatter getObjectValue:&theDate forString:self range:nil error:&theError]) {
        return theDate;
    } else {
        NSLog(@"Date '%@' could not be parsed with RFC 2822 format: %@", self, theError);
        return nil;
    }
}

@end
