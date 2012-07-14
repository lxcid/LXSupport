//
//  NSArray+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSArray+LXSupportTests.h"
#import "NSArray+LXSupport.h"

@implementation NSArray_LXSupportTests

- (void)testIsEmpty {
    STAssertTrue([[NSArray array] isEmpty], @"Array should be empty.");
}

- (void)testFirstObject {
    NSMutableArray *theBank = [NSMutableArray arrayWithObject:@"$1,000,000"];
    STAssertEqualObjects([theBank firstObject], @"$1,000,000", @"Who stolen my money!!!");
    [theBank removeObject:[theBank firstObject]];
    STAssertNil([theBank firstObject], @"You must be still dreaming...");
}

@end
