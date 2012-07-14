//
//  UIColor+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 14/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LXSupport)

#pragma mark - Decimal Notation

+ (UIColor *)colorInDecimalNotationWithRed:(UInt8)theRed green:(UInt8)theGreen blue:(UInt8)theBlue alpha:(CGFloat)theAlpha;

#pragma mark - Hex Triplet

// http://en.wikipedia.org/wiki/Web_colors#Hex_triplet
+ (NSRegularExpression *)hexTripletRegularExpression;
// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *)colorWithHexTriplet:(unsigned int)theHexTriplet alpha:(CGFloat)theAlpha;
+ (UIColor *)colorWithHexTriplet:(unsigned int)theHexTriplet;
+ (UIColor *)colorWithHexTripletInString:(NSString *)theHexTripletInString alpha:(CGFloat)theAlpha;
+ (UIColor *)colorWithHexTripletInString:(NSString *)theHexTripletInString;

@end
