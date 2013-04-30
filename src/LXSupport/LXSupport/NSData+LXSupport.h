//
//  NSData+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LXSupport)

- (NSData *)dataByHmacSHA1WithKey:(NSData *)theKey;
- (NSString *)stringByEncodeUsingBase64;
- (NSString *)hexadecimalString;

@end
