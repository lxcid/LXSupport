//
//  NSString+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 20/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSString+LXSupportTests.h"
#import "NSString+LXSupport.h"

@implementation NSString_LXSupportTests

- (void)testRandomGeneratedString {
    {
        NSString *theRandomString = [NSString stringByRandomlyGeneratedFromAlphanumericSetWithLength:128];
        NSCharacterSet *theNonAlphanumericCharacterSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        STAssertTrue([theRandomString rangeOfCharacterFromSet:theNonAlphanumericCharacterSet].location == NSNotFound, @"Must not contains non alphanumeric character set.");
        STAssertTrue(theRandomString.length == 128, @"Must pass equality test.");
    }
}

@end
