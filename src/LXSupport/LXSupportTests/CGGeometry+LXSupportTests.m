//
//  CGGeometry+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 19/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "CGGeometry+LXSupportTests.h"
#import "CGGeometry+LXSupport.h"
#import <UIKit/UIKit.h>

@implementation CGGeometry_LXSupportTests

- (void)testCGSizeExtensions {
    {
        CGSize theSize1 = CGSizeMake(5.0f, 20.0f);
        CGSize theSize2 = CGSizeMake(10.0f, 40.0f);
        STAssertTrue(CGSizeEqualToSize(LXS_CGSizeAdd(theSize1, theSize2), CGSizeMake(15.0f, 60.0f)), @"Must pass equality test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeFromAngleAndDistance(-M_PI_2, 1.0f);
        STAssertEqualsWithAccuracy(theSize.width, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, 1.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeFromAngleAndDistance(0.0f, 3.0f);
        STAssertEqualsWithAccuracy(theSize.width, 3.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeFromAngleAndDistance(M_PI_2, 5.0f);
        STAssertEqualsWithAccuracy(theSize.width, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, -5.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeFromAngleAndDistance(M_PI, 2.0f);
        STAssertEqualsWithAccuracy(theSize.width, -2.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeFromAngleAndDistance(3.0f * M_PI / 2.0f, 10.0f);
        STAssertEqualsWithAccuracy(theSize.width, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, 10.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    
    {
        CGSize theSize = LXS_CGSizeOfShadowFromAngleAndDistance(0.0f, 3.0f);
        STAssertEqualsWithAccuracy(theSize.width, -3.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeOfShadowFromAngleAndDistance(M_PI_2, 5.0f);
        STAssertEqualsWithAccuracy(theSize.width, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, 5.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeOfShadowFromAngleAndDistance(M_PI, 2.0f);
        STAssertEqualsWithAccuracy(theSize.width, 2.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
    
    {
        CGSize theSize = LXS_CGSizeOfShadowFromAngleAndDistance(3.0f * M_PI / 2.0f, 10.0f);
        STAssertEqualsWithAccuracy(theSize.width, 0.0f, 0.000001f, @"Must pass equality with accuracy test.");
        STAssertEqualsWithAccuracy(theSize.height, -10.0f, 0.000001f, @"Must pass equality with accuracy test.");
    }
}

@end
