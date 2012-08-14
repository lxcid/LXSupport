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

+ (NSString *)stringByEncodeUsingBase64WithData:(NSData *)theData {
    // I have a habit of trying to describe something as accurate as possible, even at the expense of performance...
    NSUInteger theInputLength = theData.length;
    const char *theInputBytes = theData.bytes;
    
    // Calculating the result length
    double theNumerator = (double)theInputLength;
    double theRemainder = fmod(theNumerator, 3.0);
    double theIntegralQuotient = theNumerator - theRemainder;
    NSUInteger theOutputLength = ((NSUInteger)theIntegralQuotient / 3) * 4;
    if (theRemainder > 0.0) { // Required padding
        theOutputLength += 4;
    }
    char *theOutputBytes = malloc(theOutputLength * sizeof(char));
    
    static const char theLookupTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    NSUInteger theInputIndex = 0;
    NSUInteger theOutputIndex = 0;
    for (theInputIndex = 0; theInputIndex < (theInputLength - 2); theInputIndex += 3) {
        // First 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex] & 0xFC) >> 2)];
        theOutputIndex++;
        
        // Next 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex] & 0x03) << 4) | ((theInputBytes[theInputIndex + 1] & 0xF0) >> 4)];
        theOutputIndex++;
        
        // Next 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex + 1] & 0x0F) << 2) | ((theInputBytes[theInputIndex + 2] & 0xC0) >> 6)];
        theOutputIndex++;
        
        // Last 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[(theInputBytes[theInputIndex + 2] & 0x3F)];
        theOutputIndex++;
        
        // TODO: (khinboon@d--buzz.com) Possible place to insert wrapping code.
    }
    
    // Handles left over input bytes.
    if (theInputIndex == (theInputLength - 2)) { // 16 bits left over.
        // First 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex] & 0xFC) >> 2)];
        theOutputIndex++;
        
        // Next 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex] & 0x03) << 4) | ((theInputBytes[theInputIndex + 1] & 0xF0) >> 4)];
        theOutputIndex++;
        
        // Last 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex + 1] & 0x0F) << 2)];
        theOutputIndex++;
        
        // Terminates with =
        theOutputBytes[theOutputIndex] = '=';
        theOutputIndex++;
    } else if (theInputIndex == (theInputLength - 1)) {
        // First 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex] & 0xFC) >> 2)];
        theOutputIndex++;
        
        // Last 6 bits
        theOutputBytes[theOutputIndex] = theLookupTable[((theInputBytes[theInputIndex] & 0x03) << 4)];
        theOutputIndex++;
        
        // Terminates with =
        theOutputBytes[theOutputIndex] = '=';
        theOutputIndex++;
        
        // Terminates with =
        theOutputBytes[theOutputIndex] = '=';
        theOutputIndex++;
    }
    
    NSString *theBase64EncodedString = [[NSString alloc] initWithBytesNoCopy:theOutputBytes length:theOutputLength encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
    return theBase64EncodedString;
}

@end
