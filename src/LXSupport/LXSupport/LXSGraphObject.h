//
//  LXSGraphObject.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 12/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <Foundation/Foundation.h>

// https://github.com/facebook/facebook-ios-sdk/blob/master/src/FBGraphObject.h
// The rationale for cloning the implementation is to avoid having to add Facebook SDK
// just so to use this awesome feature. Nevertheless, I encourage everyone to integrate
// Facebook SDK to your app if you find this extremely helpful, in a way to repay them.
// I takes no credit in this. I just wanted to learn, have something lightweight and ARC based.
// So I hand copied the implementation and make it consistent with my coding convention.
@protocol LXSGraphObject <NSObject>

// Returns the number of properties on this `LXSGraphObject`.
- (NSUInteger)count;

// Returns a property on this `LXSGraphObject`.
- (id)objectForKey:(id)theKey;

// Returns an enumerator of the property names on this `LXSGraphObject`.
- (NSEnumerator *)keyEnumerator;

// Removes a property on this `LXSGraphObject`.
- (void)removeObjectForKey:(id)theKey;

// Set the value of a property on this `LXSGraphObject`.
- (void)setObject:(id)theObject forKey:(id)theKey;

@end

// Static class with helpers for use with graph objects
@interface LXSGraphObject : NSMutableDictionary<LXSGraphObject>

// Used to create a graph object for, usually for use in posting a new graph object or action.
+ (NSMutableDictionary<LXSGraphObject> *)graphObject;

// Used to wrap an existing dictionary with a `LXSGraphObject` facade.
+ (NSMutableDictionary<LXSGraphObject> *)graphObjectWrappingDictionary:(NSDictionary *)theJSONDictionary;

// Used to compare two `LXSGraphObject` to determine if represent the same object.
+ (BOOL)isGraphObjectID:(id<LXSGraphObject>)theObject sameAs:(id<LXSGraphObject>)theAnotherObject;

@end
