//
//  LXSHelperOfNSData.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXSHelperOfNSData : NSObject

// http://stackoverflow.com/a/2778608/379604
+ (NSData *)dataByDigestUsingHMACMD5WithData:(NSData *)theData key:(NSData *)theKey;

// https://github.com/nicklockwood/Base64/blob/master/Base64/NSData%2BBase64.m
// http://tools.ietf.org/html/rfc2045#page-24
// http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html
// https://github.com/mattt/AFOAuth1Client/blob/master/AFHTTPClient.m
// TODO: (khinboon@d--buzz.com) Handles new line.
+ (NSString *)stringByEncodeUsingBase64WithData:(NSData *)theData;
+ (NSData *)dataByDecodeUsingBase64WithData:(NSData *)theData;

// TODO: (khinboon@d--buzz.com) MD5

@end
