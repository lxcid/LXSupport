//
//  LXSGraphObjectTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 13/8/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "LXSGraphObjectTests.h"
#import "LXSGraphObject.h"

@protocol LXSPhoneGraphObject <LXSGraphObject>

@property (copy, nonatomic) NSString *manufacturer;
@property (copy, nonatomic) NSString *model;

@end

@protocol LXSUserGraphObject <LXSGraphObject>

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSMutableDictionary<LXSUserGraphObject> *girlfriend;
@property (strong, nonatomic) NSMutableDictionary<LXSPhoneGraphObject> *phone;

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
    
    STAssertNil(theUser.girlfriend, @"The user's girlfriend should be nil.");
    theUser.girlfriend = (NSMutableDictionary<LXSUserGraphObject> *)[LXSGraphObject graphObject];
    STAssertNil(theUser.girlfriend.name, @"The user's girlfriend's name should be nil.");
    STAssertNil(theUser.girlfriend.age, @"The user's girlfriend's age should be nil.");
    theUser.girlfriend.name = @"Minty";
    STAssertEqualObjects(theUser.girlfriend.name, @"Minty", @"The user's girlfriend's name should be Minty.");
    
    STAssertNil(theUser.phone, @"The user's phone should be nil.");
    [theUser
     setObject:@{ @"manufacturer" : @"Apple" , @"model" : @"iPhone 4S" }
     forKey:@"phone"];
    STAssertEqualObjects(theUser.phone.manufacturer, @"Apple", @"The user's phone's manufacturer should be Apple.");
    STAssertEqualObjects(theUser.phone.model, @"iPhone 4S", @"The user's phone's model should be iPhone 4S.");
    NSLog(@"%@", theUser);
}

@end
