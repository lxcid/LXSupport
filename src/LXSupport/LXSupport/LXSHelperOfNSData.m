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

+ (NSData *)dataByDecodeUsingBase64WithData:(NSData *)theData {
    uint8_t *theInput = (uint8_t *)theData.bytes;
    NSUInteger theLength = theData.length;
    
    NSUInteger theOutputLength = ((theLength + 3) / 4) * 3;
    if (theInput[theLength - 1] == 61) {
        if (theInput[theLength - 2] == 61) {
            theOutputLength -= 2;
        } else {
            theOutputLength -= 1;
        }
    }
    
    NSMutableData *theBase64DecodedData = [NSMutableData dataWithLength:theOutputLength];
    
    uint8_t *theOutput = (uint8_t *)theBase64DecodedData.mutableBytes;
    
    // Reference http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html
    // Our algorithm, which is derived from mattt's base 64 encoding and uses Matt Gallagher
    // base 64 decoding table, uses 0 instead of xx (either 'A' or masked-out area) as it won't
    // cause any side effects. :)
    static uint8_t const theBase64DecodingTable[] = {
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 62,  0,  0,  0, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61,  0,  0,  0,  0,  0,  0,
         0,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,  0,  0,  0,  0,  0,
         0, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
         0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
    };
    
    for (NSUInteger theIndex = 0; theIndex < theLength; theIndex += 4) {
        NSUInteger theValue = 0;
        for (NSUInteger theOtherIndex = 0; theOtherIndex < (theIndex + 4); theOtherIndex++) {
            theValue <<= 6;
            if (theOtherIndex < theLength) {
                theValue |= (0x3F & theBase64DecodingTable[theInput[theOtherIndex]]);
            }
        }
        
        NSUInteger theOutputIndex = (theIndex / 4) * 3;
        theOutput[theOutputIndex + 0] = (theValue >> 16) & 0xFF;
        theOutput[theOutputIndex + 1] = (theValue >> 8) & 0xFF;
        theOutput[theOutputIndex + 2] = (theValue >> 0) & 0xFF;
    }
    
    return [NSData dataWithData:theBase64DecodedData];
}

@end
