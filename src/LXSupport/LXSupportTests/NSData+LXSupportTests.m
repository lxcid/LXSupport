//
//  NSData+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSData+LXSupportTests.h"
#import "NSData+LXSupport.h"

@implementation NSData_LXSupportTests

- (void)testHMACSHA1 {
    STFail(@"Test HmacSHA1");
}

- (void)testBase64Encoding {
    // Left 16 bytes
    {
        NSData *theBase64DecodedData = [@"Send reinforcements" dataUsingEncoding:NSASCIIStringEncoding];
        NSString *theBase64EncodedString = [theBase64DecodedData stringByEncodeUsingBase64];
        STAssertEqualObjects(theBase64EncodedString, @"U2VuZCByZWluZm9yY2VtZW50cw==", @"The data should match.");
    }
    
    // Left 8 bytes
    {
        NSData *theBase64DecodedData = [@"Additional Supply Depot required" dataUsingEncoding:NSASCIIStringEncoding];
        NSString *theBase64EncodedString = [theBase64DecodedData stringByEncodeUsingBase64];
        STAssertEqualObjects(theBase64EncodedString, @"QWRkaXRpb25hbCBTdXBwbHkgRGVwb3QgcmVxdWlyZWQ=", @"The data should match.");
    }
    
    // Left 0 bytes
    {
        NSData *theBase64DecodedData = [@"Reinforcements have arrived" dataUsingEncoding:NSASCIIStringEncoding];
        NSString *theBase64EncodedString = [theBase64DecodedData stringByEncodeUsingBase64];
        STAssertEqualObjects(theBase64EncodedString, @"UmVpbmZvcmNlbWVudHMgaGF2ZSBhcnJpdmVk", @"The data should match.");
    }
}

@end
