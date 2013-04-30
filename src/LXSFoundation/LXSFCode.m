#import "LXSFCode.h"

@implementation LXSFCode


#pragma mark - LXSFHexadecimal methods

+ (NSString *)stringByEncodingWithHexadecimalFromData:(NSData *)decodedData {
    const uint8_t *decodedDataInBytes = (const uint8_t *)decodedData.bytes;
    NSUInteger decodedDataLength = decodedData.length;
    
    NSUInteger encodedStringLength = decodedDataLength * 2;
    NSMutableString *encodedString = [NSMutableString stringWithCapacity:encodedStringLength];
    
    for (NSUInteger index = 0; index < decodedDataLength; index++) {
        [encodedString appendFormat:@"%02X", decodedDataInBytes[index]];
    }
    
    return [encodedString copy];
}

+ (NSData *)dataByDecodingWithHexadeciamlFromString:(NSString *)encodedString {
    // TODO: (khinboon@gmail.com) Not implemented.
    return nil;
}


#pragma mark - LXSFBase64 methods

+ (NSString *)stringByEncodingWithBase64FromData:(NSData *)decodedData {
    NSUInteger decodedDataLength = decodedData.length;
    NSMutableData *encodedData = [NSMutableData dataWithLength:((decodedDataLength + 2) / 3) * 4];
    
    const uint8_t *input = (const uint8_t *)decodedData.bytes;
    uint8_t *output = (uint8_t *)encodedData.mutableBytes;
    
    for (NSUInteger index = 0; index < decodedDataLength; index += 3) {
        NSUInteger value = 0;
        for (NSUInteger otherIndex = 0; otherIndex < (index + 3); otherIndex++) {
            value <<= 8;
            if (otherIndex < decodedDataLength) {
                value |= (0xFF & input[otherIndex]);
            }
        }
        
        static uint8_t const base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger outputIndex = (index / 3) * 4;
        output[outputIndex + 0] = base64EncodingTable[(value >> 18) & 0x3F];
        output[outputIndex + 1] = base64EncodingTable[(value >> 12) & 0x3F];
        output[outputIndex + 2] = ((index + 1) < decodedDataLength) ? base64EncodingTable[(value >> 6) & 0x3F] : '=';
        output[outputIndex + 3] = ((index + 2) < decodedDataLength) ? base64EncodingTable[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:encodedData encoding:NSASCIIStringEncoding];
}

+ (NSData *)dataByDecodingWithBase64FromString:(NSString *)encodedString {
    NSData *encodedData = [encodedString dataUsingEncoding:NSASCIIStringEncoding];
    const uint8_t *input = (const uint8_t *)encodedData.bytes;
    NSUInteger encodedDataLength = encodedData.length;
    
    NSUInteger outputLength = ((encodedDataLength + 3) / 4) * 3;
    if (input[encodedDataLength - 1] == 61) {
        if (input[encodedDataLength - 2] == 61) {
            outputLength -= 2;
        } else {
            outputLength -= 1;
        }
    }
    
    NSMutableData *decodedData = [NSMutableData dataWithLength:outputLength];
    
    uint8_t *theOutput = (uint8_t *)decodedData.mutableBytes;
    
    static uint8_t const base64DecodingTable[256] = {
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
    
    for (NSUInteger index = 0; index < encodedDataLength; index += 4) {
        NSUInteger value = 0;
        for (NSUInteger otherIndex = index; otherIndex < (index + 4); otherIndex++) {
            value <<= 6;
            if (otherIndex < encodedDataLength) {
                value |= (0x3F & base64DecodingTable[input[otherIndex]]);
            }
        }
        
        NSUInteger outputIndex = (index / 4) * 3;
        theOutput[outputIndex + 0] = (value >> 16) & 0xFF;
        theOutput[outputIndex + 1] = (value >> 8) & 0xFF;
        theOutput[outputIndex + 2] = (value >> 0) & 0xFF;
    }
    
    return [NSData dataWithData:decodedData];
}

@end
