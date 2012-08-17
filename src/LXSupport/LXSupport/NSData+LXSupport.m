//
//  NSData+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSData+LXSupport.h"
#import "LXSHelperOfNSData.h"

@implementation NSData (LXSupport)

- (NSData *)dataByHmacSHA1WithKey:(NSData *)theKey {
    return [LXSHelperOfNSData dataByDigestUsingHMACMD5WithData:self key:theKey];
}

- (NSString *)stringByEncodeUsingBase64 {
    return [LXSHelperOfNSData stringByEncodeUsingBase64WithData:self];
}

- (NSData *)dataByDecodeUsingBase64 {
    return [LXSHelperOfNSData dataByDecodeUsingBase64WithData:self];
}

@end
