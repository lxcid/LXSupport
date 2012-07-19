//
//  CGGeometry+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 19/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "CGGeometry+LXSupportTests.h"
#import "CGGeometry+LXSupport.h"

@implementation CGGeometry_LXSupportTests

- (void)testCGSizeExtensions {
    CGSize theSize1 = CGSizeMake(5.0f, 20.0f);
    CGSize theSize2 = CGSizeMake(10.0f, 40.0f);
    STAssertTrue(CGSizeEqualToSize(LXS_CGSizeAdd(theSize1, theSize2), CGSizeMake(15.0f, 60.0f)), @"Must pass equality test.");
}

@end
