//
//  UIColor+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "UIColor+LXSupportTests.h"
#import "UIColor+LXSupport.h"

@implementation UIColor_LXSupportTests

- (void)testDecimalNotation {
    // TODO: (khinboon@d--buzz.com) Explains why can't we use [UIColor whiteColor].
    STAssertEqualObjects([UIColor colorInDecimalNotationWithRed:255 green:255 blue:255 alpha:1.0f],
                         [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f],
                         @"The colors should be equal.");
    STAssertEqualObjects([UIColor colorInDecimalNotationWithRed:102 green:102 blue:102 alpha:1.0f],
                         [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f],
                         @"The colors should be equal.");
    STAssertEqualObjects([UIColor colorInDecimalNotationWithRed:0 green:51 blue:102 alpha:0.5f],
                         [UIColor colorWithRed:0.0f green:0.2f blue:0.4f alpha:0.5f],
                         @"The colors should be equal.");
}

- (void)testHexTriplet {
    STAssertEqualObjects([UIColor colorWithHexTriplet:0x00FF00],
                         [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f],
                         @"The colors should be equal.");
    STAssertEqualObjects([UIColor colorWithHexTriplet:0xFFFFFF alpha:0.6f],
                         [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.6f],
                         @"The colors should be equal.");
    STAssertEqualObjects([UIColor colorWithHexTripletInString:@"#996633"],
                         [UIColor colorWithRed:0.6f green:0.4f blue:0.2f alpha:1.0f],
                         @"The colors should be equal.");
    STAssertEqualObjects([UIColor colorWithHexTripletInString:@"996633" alpha:0.1f],
                         [UIColor colorWithRed:0.6f green:0.4f blue:0.2f alpha:0.1f],
                         @"The colors should be equal.");
    STAssertNil([UIColor colorWithHexTripletInString:@"This is not a hex triplet color string yo!"], @"The color should be nil.");
}

@end
