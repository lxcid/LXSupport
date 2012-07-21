//
//  Math+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 21/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "Math+LXSupportTests.h"
#import "Math+LXSupport.h"

@implementation Math_LXSupportTests

- (void)testDegreesAndRadiansConversion {
    STAssertEquals(LXS_DegreesToRadians(180.0f), (CGFloat)M_PI, @"Must pass equality test.");
    STAssertEquals(LXS_RadiansToDegrees(M_PI * 2.0f), 360.0f, @"Must pass equality test.");
}

@end
