//
//  LXSGraphObjectTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 13/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "LXSGraphObjectTests.h"
#import "LXSGraphObject.h"

@protocol LXSUserGraphObject <LXSGraphObject>

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;

@end

@implementation LXSGraphObjectTests

- (void)testLXSUserGraphObject {
    NSMutableDictionary<LXSUserGraphObject> *theUser = (NSMutableDictionary<LXSUserGraphObject> *)[LXSGraphObject graphObject];
    STAssertNil(theUser.name, @"The user's name should be nil.");
    STAssertNil(theUser.age, @"The user's age should be nil.");
    theUser.name = @"Stan Chang Khin Boon";
    STAssertEqualObjects(theUser.name, @"Stan Chang Khin Boon", @"The user's name should be Stan Chang Khin Boon.");
    theUser.age = @26;
    STAssertEqualObjects(theUser.age, @26, @"The user's age should be 26.");
}

@end
