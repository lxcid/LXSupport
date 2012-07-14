//
//  NSArray+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LXSupport)

- (BOOL)isEmpty;

// Returns the object in the array with the lowest index value.
// The object in the array with the lowest index value. If the array is empty, returns nil.
- (id)firstObject;

@end
