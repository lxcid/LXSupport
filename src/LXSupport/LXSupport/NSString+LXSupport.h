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

- (NSDate *)dateInRFC3339;
- (NSDate *)dateInRFC2822;

@end
