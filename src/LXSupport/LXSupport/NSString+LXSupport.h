//
//  NSString+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 30/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LXSupport)

+ (NSString *)stringByRandomlyGeneratedFromAlphanumericSetWithLength:(NSUInteger)theLength;

// http://developer.apple.com/library/ios/#qa/qa1480/_index.html
// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW1
// TODO: (khinboon@d--buzz.com) This does not handle all the possible RFC3339 format, we might need a regular expression to detect the right format to use, which can be expensive.
- (NSDate *)dateInRFC3339;
- (NSDate *)dateInRFC2822;

- (NSString *)stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)theStringEncoding includeReservedCharacters:(BOOL)isReservedCharactersIncluded;
- (NSDictionary *)queryStringAsParametersDictionary;

- (BOOL)isEmpty;

- (NSData *)dataByDecodeUsingBase64;

@end
