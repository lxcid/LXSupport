#import <Foundation/Foundation.h>

/** LXSFCode provides class methods for encoding and decoding various type of codes.
 
 The currently supported codes are:
 
 - Hexadecimal
 - Base64
 */
@interface LXSFCode : NSObject
@end

/** @name Hexadecimal
 */

@interface LXSFCode (LXSFHexadecimal)

/** Encodes data into a hexadecimal string.
 @param data The decoded data.
 @return Encoded hexadecimal string.
 */
+ (NSString *)stringByEncodingWithHexadecimalFromData:(NSData *)decodedData;

/** Decodes hexadecimal string into data.
 @param string The encoded hexadecimal string.
 @return Decoded data.
 @warning *Warning:* Not implemented.
 */
+ (NSData *)dataByDecodingWithHexadeciamlFromString:(NSString *)encodedString;

@end

/** @name Base64
 The base64 encoding implementation is taken from [Mattt Thompson's AFOAuth1Client implementation](https://github.com/mattt/AFOAuth1Client/blob/master/AFHTTPClient.m).
 
 The base64 decoding implementation is referenced from the encoding implementation, which focuses on a 2 passes implementation as oppose to a single pass that most other solution implemented.
 
 It uses a slight variant of the decoding table referenced from [Matt Gallagher's Base64 encoding options on the Mac and iPhone post](http://www.cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html) which uses 0 instead of xx for either 'A' or masked-out area as it won't cause any side effects.
 
 Some other solutions/materials I had studied and given consideration are listed below:
 
 - https://github.com/nicklockwood/Base64/blob/master/Base64/NSData%2BBase64.m
 - http://tools.ietf.org/html/rfc2045#page-24
 
 @warning *Warning:* The decoding operation does not supports encoded base64 string with new lines.
 */
@interface LXSFCode (LXSFBase64)

/** Encodes data into a base64 string.
 @param data The decoded data.
 @return Encoded base64 string.
 */
+ (NSString *)stringByEncodingWithBase64FromData:(NSData *)decodedData;

/** Decodes base64 string into data.
 @param string The encoded base64 string.
 @return Decoded data.
 */
+ (NSData *)dataByDecodingWithBase64FromString:(NSString *)encodedString;

@end
