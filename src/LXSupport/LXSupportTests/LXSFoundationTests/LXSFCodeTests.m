//
//  CGGeometry+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 19/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "LXSFCodeTests.h"
#import "LXSFCode.h"

@implementation LXSFCodeTests

#pragma mark - Test LXSFHexadecimal methods

- (void)testHexadecimalEncoding {
    STFail(@"Not yet implemented.");
}

- (void)testHexadecimalDecoding {
    STFail(@"Not yet implemented.");
}

#pragma mark - Test LXSFBase64 methods

- (void)testBase64Encoding {
    // Left 16 bytes
    {
        NSData *decodedData = [@"Send reinforcements" dataUsingEncoding:NSASCIIStringEncoding];
        NSString *encodedString = [LXSFCode stringByEncodingWithBase64FromData:decodedData];
        STAssertEqualObjects(encodedString, @"U2VuZCByZWluZm9yY2VtZW50cw==", @"The data should match.");
    }
    
    // Left 8 bytes
    {
        NSData *decodedData = [@"Additional Supply Depot required" dataUsingEncoding:NSASCIIStringEncoding];
        NSString *encodedString = [LXSFCode stringByEncodingWithBase64FromData:decodedData];
        STAssertEqualObjects(encodedString, @"QWRkaXRpb25hbCBTdXBwbHkgRGVwb3QgcmVxdWlyZWQ=", @"The data should match.");
    }
    
    // Left 0 bytes
    {
        NSData *decodedData = [@"Reinforcements have arrived" dataUsingEncoding:NSASCIIStringEncoding];
        NSString *encodedString = [LXSFCode stringByEncodingWithBase64FromData:decodedData];
        STAssertEqualObjects(encodedString, @"UmVpbmZvcmNlbWVudHMgaGF2ZSBhcnJpdmVk", @"The data should match.");
    }
}

- (void)testBase64Decoding {
    // Left 16 bytes
    {
        NSString *encodedString = @"U2VuZCByZWluZm9yY2VtZW50cw==";
        NSData *decodedData = [LXSFCode dataByDecodingWithBase64FromString:encodedString];
        STAssertEqualObjects(decodedData, [@"Send reinforcements" dataUsingEncoding:NSASCIIStringEncoding], @"The data should match.");
    }
    
    // Left 8 bytes
    {
        NSString *encodedString = @"QWRkaXRpb25hbCBTdXBwbHkgRGVwb3QgcmVxdWlyZWQ=";
        NSData *decodedData = [LXSFCode dataByDecodingWithBase64FromString:encodedString];
        STAssertEqualObjects(decodedData, [@"Additional Supply Depot required" dataUsingEncoding:NSASCIIStringEncoding], @"The data should match.");
    }
    
    // Left 0 bytes
    {
        NSString *encodedString = @"UmVpbmZvcmNlbWVudHMgaGF2ZSBhcnJpdmVk";
        NSData *decodedData = [LXSFCode dataByDecodingWithBase64FromString:encodedString];
        STAssertEqualObjects(decodedData, [@"Reinforcements have arrived" dataUsingEncoding:NSASCIIStringEncoding], @"The data should match.");
    }
}

@end
