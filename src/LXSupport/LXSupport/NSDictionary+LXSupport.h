//
//  NSDictionary+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LXSupport)

// Often when parsing data from external source like JSON, null value are stored as NSNull. As NSNull is an object, it doesn't behaves like nil.
// This will filter out NSNull.
- (id)safeObjectForKey:(id)theKey;

@end
