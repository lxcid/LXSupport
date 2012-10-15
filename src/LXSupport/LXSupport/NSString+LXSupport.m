//
//  NSString+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 30/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSString+LXSupport.h"

// Uses mattt one.
static inline NSDictionary *LXSParametersFromQueryString(NSString *theQueryString) {
    NSMutableDictionary *theParameters = [NSMutableDictionary dictionary];
    if (theQueryString) {
        NSScanner *theParameterScanner = [[NSScanner alloc] initWithString:theQueryString];
        NSString *theKey = nil;
        NSString *theValue = nil;
        while (!theParameterScanner.isAtEnd) {
            theKey = nil;
            [theParameterScanner scanUpToString:@"=" intoString:&theKey];
            [theParameterScanner scanString:@"=" intoString:NULL];
            
            theValue = nil;
            [theParameterScanner scanUpToString:@"&" intoString:&theValue];
            [theParameterScanner scanString:@"&" intoString:NULL];
            
            if (theKey && theValue) {
                [theParameters setValue:[theValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                 forKey:[theKey stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    return theParameters;
}

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
    if ([self hasSuffix:@"Z"]) { // 2012-07-30T04:13:28Z
        NSDateFormatter *theDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        theDateFormatter.locale = theLocale;
        NSTimeZone *theTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        theDateFormatter.timeZone = theTimeZone;
        NSDate *theDate = nil;
        NSError *theError = nil;
        theDateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
        if ([theDateFormatter getObjectValue:&theDate forString:self range:nil error:&theError]) {
            return theDate;
        } else {
            NSLog(@"Date '%@' could not be parsed with RFC 3339 format: %@", self, theError);
            return nil;
        }
    } else {
        NSDateFormatter *theDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *theLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        theDateFormatter.locale = theLocale;
        NSDate *theDate = nil;
        NSError *theError = nil;
        theDateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ";
        if ([theDateFormatter getObjectValue:&theDate forString:self range:nil error:&theError]) {
            return theDate;
        } else {
            NSLog(@"Date '%@' could not be parsed with RFC 3339 format: %@", self, theError);
            return nil;
        }
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

// Uses mattt afnetworking legal characters set and solution.
- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)theStringEncoding includeReservedCharacters:(BOOL)isReservedCharactersIncluded {
    if (isReservedCharactersIncluded) {
        static NSString * const theLegalCharactersToBeEscaped = @"?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ ";
        return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)theLegalCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(theStringEncoding));
    } else {
        return [self stringByAddingPercentEscapesUsingEncoding:theStringEncoding];
    }
}

- (NSDictionary *)queryStringAsParametersDictionary {
    return LXSParametersFromQueryString(self);
}

- (BOOL)isEmpty {
    return [self isEqualToString:@""];
}

@end
