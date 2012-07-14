//
//  NSDictionary+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSDictionary+LXSupportTests.h"
#import "NSDictionary+LXSupport.h"

@implementation NSDictionary_LXSupportTests

- (void)testSafeObject {
    NSDictionary *theMe =
    [NSDictionary
     dictionaryWithObjectsAndKeys:
     [NSNull null], @"Millionaire yet?",
     nil];
    STAssertNil([theMe safeObjectForKey:@"Millionaire yet?"], @"I am a millionaire? You must be joking!");
}

@end
