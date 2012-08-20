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

- (void)testURLEncoding {
    {
        NSString *theLegalCharactersToBeEscaped = @"?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ ";
        STAssertEqualObjects([theLegalCharactersToBeEscaped stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding includeReservedCharacters:YES], @"%3F%21%40%23%24%5E%26%25%2A%2B%3D%2C%3A%3B%27%22%60%3C%3E%28%29%5B%5D%7B%7D%2F%5C%7C%7E%20", @"Must pass equality test.");
        
        STAssertFalse([@"%3F%21%40%23%24%5E%26%25%2A%2B%3D%2C%3A%3B%27%22%60%3C%3E%28%29%5B%5D%7B%7D%2F%5C%7C%7E%20" isEqualToString:[theLegalCharactersToBeEscaped stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding includeReservedCharacters:NO]], @"Must fail equality test.");
    }
}

@end
