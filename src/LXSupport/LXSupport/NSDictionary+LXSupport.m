//
//  NSDictionary+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSDictionary+LXSupport.h"

@implementation NSDictionary (LXSupport)

- (id)safeObjectForKey:(id)theKey {
    id theValue = [self objectForKey:theKey];
    return [[NSNull null] isEqual:theValue] ? nil : theValue;
}

@end
