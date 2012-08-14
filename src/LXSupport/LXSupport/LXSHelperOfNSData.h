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
// TODO: (khinboon@d--buzz.com) Decoder
// TODO: (khinboon@d--buzz.com) Handles new line.
+ (NSString *)stringByEncodeUsingBase64WithData:(NSData *)theData;

// TODO: (khinboon@d--buzz.com) MD5

@end
