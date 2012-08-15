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

// https://github.com/mattt/AFOAuth1Client/blob/master/AFHTTPClient.m
// I loves mattt implementation the most. The cleanest I have seen.
+ (NSString *)stringByEncodeUsingBase64WithData:(NSData *)theData {
    NSUInteger theLength = theData.length;
    NSMutableData *theBase64EncodedData = [NSMutableData dataWithLength:((theLength + 2) / 3) * 4];
    
    uint8_t *theInput = (uint8_t *)theData.bytes;
    uint8_t *theOutput = (uint8_t *)theBase64EncodedData.mutableBytes;
    
    for (NSUInteger theIndex = 0; theIndex < theLength; theIndex += 3) {
        NSUInteger theValue = 0;
        for (NSUInteger theOtherIndex = 0; theOtherIndex < (theIndex + 3); theOtherIndex++) {
            theValue <<= 8;
            if (theOtherIndex < theLength) {
                theValue |= (0xFF & theInput[theOtherIndex]);
            }
        }
        
        static uint8_t const theBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger theOutputIndex = (theIndex / 3) * 4;
        theOutput[theOutputIndex + 0] = theBase64EncodingTable[(theValue >> 18) & 0x3F];
        theOutput[theOutputIndex + 1] = theBase64EncodingTable[(theValue >> 12) & 0x3F];
        theOutput[theOutputIndex + 2] = ((theIndex + 1) < theLength) ? theBase64EncodingTable[(theValue >> 6) & 0x3F] : '=';
        theOutput[theOutputIndex + 3] = ((theIndex + 2) < theLength) ? theBase64EncodingTable[(theValue >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:theBase64EncodedData encoding:NSASCIIStringEncoding];
}

@end
