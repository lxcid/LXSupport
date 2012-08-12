//
//  LXSGraphObject.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 12/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "LXSGraphObject.h"
#import <objc/runtime.h>

static NSString *const LXSIsGraphObjectKey = @"com.d--buzz.LXSIsGraphObjectKey";

// Used internally by the category impl.
typedef enum LXSSelectorInferredImplType : NSUInteger {
    LXSSelectorInferredImplTypeNone = 0,
    LXSSelectorInferredImplTypeGet = 1,
    LXSSelectorInferredImplTypeSet = 2
} LXSSelectorInferredImplType;

// Internal-only wrapper
@interface LXSGraphObjectArray : NSMutableArray

- (id)initWrappingArray:(NSArray *)theOtherArray;
- (id)graphObjectifyAtIndex:(NSUInteger)theIndex;
- (void)graphObjectifyAll;

@end

@interface LXSGraphObject ()

+ (id)graphObjectWrappingObject:(id)theOriginalObject __attribute((ns_returns_retained));
+ (LXSSelectorInferredImplType)inferredImplTypeForSelector:(SEL)theSelector;
+ (BOOL)isProtocolImplementationInferable:(Protocol *)theProtocol checkLXSGraphObjectAdoption:(BOOL)theCheckAdoption;

@property (strong, nonatomic) NSMutableDictionary *jsonObject;

- (id)initWrappingDictionary:(NSDictionary *)theOtherDictionary;
- (id)graphObjectifyAtKey:(id)theKey;
- (void)graphObjectifyAll;

@end

@implementation LXSGraphObject

#pragma mark Lifecycle

- (id)initWrappingDictionary:(NSDictionary *)theOtherDictionary {
    self = [super init];
    if (self) {
        if ([theOtherDictionary isKindOfClass:[LXSGraphObject class]]) {
            // In this case, we prefer to return the original object,
            // rather than allocate a wrapper.
            
            // No wrapper needed, returning the object that was provided.
            return (LXSGraphObject *)theOtherDictionary;
        } else {
            self.jsonObject = [NSMutableDictionary dictionaryWithDictionary:theOtherDictionary];
        }
    }
    return self;
}

#pragma mark - Public class methods

+ (NSMutableDictionary<LXSGraphObject> *)graphObject __attribute((ns_returns_retained)) {
    return [LXSGraphObject graphObjectWrappingDictionary:[NSMutableDictionary dictionary]];
}

+ (NSMutableDictionary<LXSGraphObject> *)graphObjectWrappingDictionary:(NSDictionary *)theJSONDictionary __attribute((ns_returns_retained)) {
    return [LXSGraphObject graphObjectWrappingObject:theJSONDictionary];
}

+ (BOOL)isGraphObjectID:(id<LXSGraphObject>)theObject sameAs:(id<LXSGraphObject>)theAnotherObject {
    if (theObject != nil && theObject == theAnotherObject) {
        return YES;
    } else {
        // TODO: (khinboon@d--buzz.com) The following equality check might not be generic enough for everyone cases.
        id theID = [theObject objectForKey:@"id"];
        id theAnotherID = [theAnotherObject objectForKey:@"id"];
        if ([theID isKindOfClass:[NSString class]] && [theAnotherObject isKindOfClass:[NSString class]]) {
            return [(NSString *)theID isEqualToString:(NSString *)theAnotherID];
        } else {
            return NO;
        }
    }
}

#pragma mark - NSObject overrides

// Make the respondsToSelector method do the right thing for the selectors we handle

- (BOOL)respondsToSelector:(SEL)theSelector {
    return ([super respondsToSelector:theSelector] || ([LXSGraphObject inferredImplTypeForSelector:theSelector] != LXSSelectorInferredImplTypeNone));
}

- (BOOL)conformsToProtocol:(Protocol *)theProtocol {
    return ([super conformsToProtocol:theProtocol] || ([LXSGraphObject isProtocolImplementationInferable:theProtocol checkLXSGraphObjectAdoption:YES]));
}

// Returns the signature for the method that we will actually invoke
- (NSMethodSignature *)methodSignatureForSelector:(SEL)theSelector {
    SEL theAlternativeSelector = theSelector;
    
    // If we should forward, to where?
    LXSSelectorInferredImplType theSelectorInferredImplType = [LXSGraphObject inferredImplTypeForSelector:theSelector];
    switch (theSelectorInferredImplType) {
        case LXSSelectorInferredImplTypeGet: {
            theAlternativeSelector = @selector(objectForKey:);
        } break;
        case LXSSelectorInferredImplTypeSet: {
            theAlternativeSelector = @selector(setObject:forKey:);
        } break;
        case LXSSelectorInferredImplTypeNone:
        default: {
            // Do nothing...
        } break;
    }
    return [super methodSignatureForSelector:theAlternativeSelector];
}

// Forwards otherwise missing selectors that match the LXSGraphObject convention
- (void)forwardInvocation:(NSInvocation *)theInvocation {
    // If we should forward, to where?
    LXSSelectorInferredImplType theSelectorInferredImplType = [LXSGraphObject inferredImplTypeForSelector:theInvocation.selector];
    switch (theSelectorInferredImplType) {
        case LXSSelectorInferredImplTypeGet: {
            // Property getter impl uses the selector name as an argument...
            NSString *thePropertyName = NSStringFromSelector(theInvocation.selector);
            [theInvocation setArgument:&thePropertyName atIndex:2];
            // ... to the replacement method objectForKey:
            theInvocation.selector = @selector(objectForKey:);
            [theInvocation invokeWithTarget:self];
        } break;
        case LXSSelectorInferredImplTypeSet: {
            // Property setter impl uses the selector name as an argument...
            NSMutableString *thePropertyName = [NSMutableString stringWithString:NSStringFromSelector(theInvocation.selector)];
            // ... remove 'set' and trailing ':', and lowercase the new first character
            [thePropertyName deleteCharactersInRange:NSMakeRange(0, 3)]; // Removes 'set'
            [thePropertyName deleteCharactersInRange:NSMakeRange(thePropertyName.length - 1, 1)]; // Removes ':'
            NSString *theFirstChar = [[thePropertyName substringWithRange:NSMakeRange(0, 1)] lowercaseString];
            [thePropertyName replaceCharactersInRange:NSMakeRange(0, 1) withString:theFirstChar];
            // ... the object argument is already in the right place (2), but  we need to set the key argument
            [theInvocation setArgument:&thePropertyName atIndex:3];
            // ... and replace the missing method with setObject:forKey:
            theInvocation.selector = @selector(setObject:forKey:);
            [theInvocation invokeWithTarget:self];
        } break;
        case LXSSelectorInferredImplTypeNone:
        default: {
            [super forwardInvocation:theInvocation];
        } break;
    }
}

#pragma mark - Private instance methods

- (id)graphObjectifyAtKey:(id)theKey {
    id theObject = [self.jsonObject objectForKey:theKey];
    // Make certain it is LXSGraphObject-ified
    id thePossibleReplacement = [LXSGraphObject graphObjectWrappingObject:theObject];
    if (theObject != thePossibleReplacement) {
        // and if not-yet,  replace the original with the wrapped object
        [self.jsonObject setObject:thePossibleReplacement forKey:theKey];
        theObject = thePossibleReplacement;
    }
    return theObject;
}

- (void)graphObjectifyAll {
    NSArray *theKeys = [self.jsonObject allKeys];
    for (NSString *theKey in theKeys) {
        [self graphObjectifyAtKey:theKey];
    }
}

#pragma mark - NSDictionary and NSMutableDictionary overrides

- (NSUInteger)count {
    return self.jsonObject.count;
}

- (id)objectForKey:(id)theKey {
    return [self graphObjectifyAtKey:theKey];
}

- (NSEnumerator *)keyEnumerator {
    [self graphObjectifyAll];
    return self.jsonObject.keyEnumerator;
}

- (void)setObject:(id)theObject forKey:(id)theKey {
    return [self.jsonObject setObject:theObject forKey:theKey];
}

- (void)removeObjectForKey:(id)theKey {
    return [self.jsonObject removeObjectForKey:theKey];
}

#pragma mark - Private class methods

+ (id)graphObjectWrappingObject:(id)theOriginalObject __attribute((ns_returns_retained)) {
    // Non-array and Non-dictionary case, return original object
    id theResult = theOriginalObject;
    
    if ([theOriginalObject isKindOfClass:[NSDictionary class]]) {
        theResult = [[LXSGraphObject alloc] initWrappingDictionary:theOriginalObject];
    } else if ([theOriginalObject isKindOfClass:[NSArray class]]) {
        theResult = [[LXSGraphObjectArray alloc] initWrappingArray:theOriginalObject];
    }
    
    // Returns our object
    return theResult;
}

// Helper method used by the category implementation to determine whether a selector should be handled.
+ (LXSSelectorInferredImplType)inferredImplTypeForSelector:(SEL)theSelector {
    // the overhead in this impl is high relative to the cost of a normal property
    // accessor; if needed we will optimize by caching results of the following
    // processing, indexed by selector
    
    NSString *theSelectorName = NSStringFromSelector(theSelector);
    NSInteger theParameterCount = [theSelectorName componentsSeparatedByString:@":"].count - 1;
    // We will process a selector as a getter if theParameterCount == 0
    if (theParameterCount == 0) {
        return LXSSelectorInferredImplTypeGet;
    } else if ((theParameterCount) == 1 &&              // otherwise we consider a setter if we have the correct arity
               ([theSelectorName hasPrefix:@"set"]) &&  // ... we have the property prefix
               (theSelectorName.length > 4)) {          // ... there are characters other than "set" & ":"
        return LXSSelectorInferredImplTypeSet;
    } else {
        return LXSSelectorInferredImplTypeNone;
    }
}

+ (BOOL)isProtocolImplementationInferable:(Protocol *)theProtocol checkLXSGraphObjectAdoption:(BOOL)theCheckAdoption {
    // First handle base protocol questions
    if ((theCheckAdoption) && (!protocol_conformsToProtocol(theProtocol, @protocol(LXSGraphObject)))) {
        return NO;
    }
    
#if __OBJC2__
    if (protocol_isEqual(theProtocol, @protocol(LXSGraphObject))) {
        return YES; // by definition
    }
#else
    if ([theProtocol isEqual:@protocol(LXSGraphObject)]) {
        return YES; // by definition
    }
#endif
    
    NSUInteger theCount = 0;
    struct objc_method_description *theMethods = NULL;
    
    // Then confirm that all methods are required
    theMethods = protocol_copyMethodDescriptionList(theProtocol, NO, YES, &theCount);
    if (theMethods) {
        free(theMethods);
        return NO;
    }
    
    @try {
        // Fetch methods of the protocol and confirm that each can be implemented automatically
        theMethods = protocol_copyMethodDescriptionList(theProtocol, YES, YES, &theCount);
        for (NSInteger theIndex; theIndex < theCount; theIndex++) {
            if ([LXSGraphObject inferredImplTypeForSelector:theMethods[theIndex].name] == LXSSelectorInferredImplTypeNone) {
                // We have a bad actor, short circuit
                return NO;
            }
        }
    } @finally {
        if (theMethods) {
            free(theMethods);
        }
    }
    
    // Fetch adopted protocols
    Protocol * __unsafe_unretained *theAdopted = NULL;
    @try {
        theAdopted = protocol_copyProtocolList(theProtocol, &theCount);
        for (NSInteger theIndex; theIndex < theCount; theIndex++) {
            if (![LXSGraphObject isProtocolImplementationInferable:theAdopted[theIndex] checkLXSGraphObjectAdoption:NO]) {
                return NO;
            }
        }
    } @finally {
        if (theAdopted) {
            free(theAdopted);
        }
    }
    
    // Protocol ran the gaunlet
    return YES;
}

@end

#pragma mark - Internal Classes

@interface LXSGraphObjectArray ()

@property (strong, nonatomic) NSMutableArray *jsonArray;

@end

@implementation LXSGraphObjectArray

- (id)initWrappingArray:(NSArray *)theOtherArray {
    self = [super init];
    if (self) {
        if ([theOtherArray isKindOfClass:[LXSGraphObjectArray class]]) {
            // In this case, we prefer to return the original object,
            // rather than allocate a wrapper
            
            return (LXSGraphObjectArray *)theOtherArray;
        } else {
            self.jsonArray = [NSMutableArray arrayWithArray:theOtherArray];
        }
    }
    return self;
}

#pragma mark - Private instance methods

- (id)graphObjectifyAtIndex:(NSUInteger)theIndex {
    id theObject = [self.jsonArray objectAtIndex:theIndex];
    // Make certain it is LXSObjectGraph-ified
    id thePossibleReplacement = [LXSGraphObject graphObjectWrappingObject:theObject];
    if (theObject != thePossibleReplacement) {
        // and if not-yet, replace the original with the wrapped object
        [self.jsonArray replaceObjectAtIndex:theIndex withObject:thePossibleReplacement];
        theObject = thePossibleReplacement;
    }
    return theObject;
}

- (void)graphObjectifyAll {
    NSInteger theCount = self.jsonArray.count;
    for (NSInteger theIndex = 0; theIndex < theCount; theIndex++) {
        [self graphObjectifyAtIndex:theIndex];
    }
}

#pragma mark - NSArray and NSMutableArray overrides

- (NSUInteger)count {
    return self.jsonArray.count;
}

- (id)objectAtIndex:(NSUInteger)theIndex {
    return [self graphObjectifyAtIndex:theIndex];
}

- (NSEnumerator *)objectEnumerator {
    [self graphObjectifyAll];
    return self.jsonArray.objectEnumerator;
}

- (NSEnumerator *)reverseObjectEnumerator {
    [self graphObjectifyAll];
    return self.jsonArray.reverseObjectEnumerator;
}

- (void)insertObject:(id)theObject atIndex:(NSUInteger)theIndex {
    [self.jsonArray insertObject:theObject atIndex:theIndex];
}

- (void)removeObjectAtIndex:(NSUInteger)theIndex {
    [self.jsonArray removeObjectAtIndex:theIndex];
}

- (void)addObject:(id)theObject {
    [self.jsonArray addObject:theObject];
}

- (void)removeLastObject {
    [self.jsonArray removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)theIndex withObject:(id)theObject {
    [self.jsonArray replaceObjectAtIndex:theIndex withObject:theObject];
}

@end




























