//
//  NSArray+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "NSArray+LXSupport.h"

@implementation NSArray (LXSupport)

- (BOOL)isEmpty {
    return (self.count == 0);
}

- (id)firstObject {
    return [self isEmpty] ? nil : [self objectAtIndex:0];
}

@end
