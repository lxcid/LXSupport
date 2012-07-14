//
//  UIColor+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "UIColor+LXSupport.h"

@implementation UIColor (LXSupport)

+ (UIColor *)colorInDecimalNotationWithRed:(UInt8)theRed green:(UInt8)theGreen blue:(UInt8)theBlue alpha:(CGFloat)theAlpha {
    return [UIColor colorWithRed:(CGFloat)theRed / (CGFloat)0xFF
                           green:(CGFloat)theGreen / (CGFloat)0xFF
                            blue:(CGFloat)theBlue / (CGFloat)0xFF
                           alpha:theAlpha];
}

+ (NSRegularExpression *)hexTripletRegularExpression {
    static NSRegularExpression *theHexTripletRegularExpression = nil;
    static dispatch_once_t theOnceToken;
    dispatch_once(&theOnceToken, ^{
        NSError *theError = nil;
        theHexTripletRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\A#?[0-9a-fA-F]{6}\\Z" options:0 error:&theError];
        if (theError) {
            NSLog(@"[WARNING] Fails to constructs the hex triplet regular expression with the following error:\n\t%@", theError.localizedDescription);
        }
    });
    return theHexTripletRegularExpression;
}

+ (UIColor *)colorWithHexTriplet:(unsigned int)theHexTriplet alpha:(CGFloat)theAlpha {
    CGFloat theRed   = ((CGFloat)((theHexTriplet & 0xFF0000) >> 16)) / 255.0f;
    CGFloat theGreen = ((CGFloat)((theHexTriplet & 0x00FF00) >> 8)) / 255.0f;
    CGFloat theBlue  = ((CGFloat)(theHexTriplet & 0x0000FF)) / 255.0f;
    return [UIColor colorWithRed:theRed green:theGreen blue:theBlue alpha:theAlpha];
}

+ (UIColor *)colorWithHexTriplet:(unsigned int)theHexTriplet {
    return [self colorWithHexTriplet:theHexTriplet alpha:1.0f];
}

+ (UIColor *)colorWithHexTripletInString:(NSString *)theHexTripletInString alpha:(CGFloat)theAlpha {
    NSRegularExpression *theHexTripletRegularExpression = [self hexTripletRegularExpression]; 
    if ([theHexTripletRegularExpression numberOfMatchesInString:theHexTripletInString options:0 range:NSMakeRange(0, theHexTripletInString.length)] == 1) {
        unsigned int theHexTriplet = 0x000000;
        NSUInteger theIndex = [theHexTripletInString hasPrefix:@"#"] ? 1 : 0;
        NSScanner *theScanner = [NSScanner scannerWithString:[theHexTripletInString substringFromIndex:theIndex]];
        if ([theScanner scanHexInt:&theHexTriplet]) {
            return [self colorWithHexTriplet:theHexTriplet alpha:theAlpha];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

+ (UIColor *)colorWithHexTripletInString:(NSString *)theHexTripletInString {
    return [self colorWithHexTripletInString:theHexTripletInString alpha:1.0f];
}

@end
