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

// TODO: (khinboon@d--buzz.com) MD5

@end
