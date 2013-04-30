//
//  LXSHelperOfNSData.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "LXSHelperOfNSData.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation LXSHelperOfNSData

+ (NSData *)dataByDigestUsingHMACMD5WithData:(NSData *)theData key:(NSData *)theKey {
    void *theMacOut = malloc(CC_SHA1_DIGEST_LENGTH);
    CCHmac(kCCHmacAlgSHA1, theKey.bytes, theKey.length, theData.bytes, theData.length, theMacOut);
    return [NSData dataWithBytesNoCopy:theMacOut length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
}

@end
