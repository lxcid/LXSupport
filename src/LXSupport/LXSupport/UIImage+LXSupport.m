//
//  UIImage+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 26/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "UIImage+LXSupport.h"

@implementation UIImage (LXSupport)

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo theImageAlphaInfo = CGImageGetAlphaInfo(self.CGImage);
    return
    (
     (theImageAlphaInfo == kCGImageAlphaFirst) ||
     (theImageAlphaInfo == kCGImageAlphaLast) ||
     (theImageAlphaInfo == kCGImageAlphaPremultipliedFirst) ||
     (theImageAlphaInfo == kCGImageAlphaPremultipliedLast)
    );
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef theImageRef = self.CGImage;
    size_t theWidth = CGImageGetWidth(theImageRef);
    size_t theHeight = CGImageGetHeight(theImageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef theOffscreenContext = CGBitmapContextCreate(NULL,
                                                             theWidth,
                                                             theHeight,
                                                             8,
                                                             0,
                                                             CGImageGetColorSpace(theImageRef),
                                                             kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(theOffscreenContext, CGRectMake(0.0f, 0.0f, (CGFloat)theWidth, (CGFloat)theHeight), theImageRef);
    CGImageRef theImageRefWithAlpha = CGBitmapContextCreateImage(theOffscreenContext);
    UIImage *theImageWithAlpha = [UIImage imageWithCGImage:theImageRefWithAlpha];
    
    // Clean up
    CGContextRelease(theOffscreenContext);
    CGImageRelease(theImageRefWithAlpha);
    
    return theImageWithAlpha;
}

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (UIImage *)borderMaskImageOfBorderSize:(NSUInteger)theBorderSize forImageSize:(CGSize)theImageSize {
    CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the image size
    CGContextRef theMaskContext = CGBitmapContextCreate(NULL,
                                                        (size_t)theImageSize.width,
                                                        (size_t)theImageSize.height,
                                                        8, // 8-bit grayscale
                                                        0,
                                                        theColorSpace,
                                                        kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(theMaskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(theMaskContext, CGRectMake(0.0f, 0.0f, theImageSize.width, theImageSize.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(theMaskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(theMaskContext, CGRectMake(theBorderSize, theBorderSize, theImageSize.width - (theBorderSize * 2.0f), theImageSize.height - (theBorderSize * 2.0f)));
    
    // Get an image of the context
    CGImageRef theMaskImageRef = CGBitmapContextCreateImage(theMaskContext);
    UIImage *theMaskImage = [UIImage imageWithCGImage:theMaskImageRef];
    
    // Clean up
    CGColorSpaceRelease(theColorSpace);
    CGContextRelease(theMaskContext);
    CGImageRelease(theMaskImageRef);
    
    return theMaskImage;
}

// Returns a copy of the image with a transparent border of the given size overlay around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)imageWithTransparentBorderOfSize:(NSUInteger)theBorderSize {
    UIImage *theImage = [self imageWithAlpha];
    UIImage *theMaskImage = [self borderMaskImageOfBorderSize:theBorderSize forImageSize:theImage.size];
    CGImageRef theTransparentBorderImageRef = CGImageCreateWithMask(theImage.CGImage, theMaskImage.CGImage);
    UIImage *theTransparentBorderImage = [UIImage imageWithCGImage:theTransparentBorderImageRef];
    
    // Clean up
    CGImageRelease(theTransparentBorderImageRef);
    
    return theTransparentBorderImage;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)imageWithAdditionalTransparentBorderOfSize:(NSUInteger)theBorderSize {
    // If the image does not have an alpha layer, add one
    UIImage *theImage = [self imageWithAlpha];
    
    CGRect theNewRect = CGRectMake(0.0f, 0.0f, theImage.size.width + (theBorderSize * 2.0f), theImage.size.height + (theBorderSize * 2.0f));
    
    // Build a context that's the same dimensions as the new size
    CGContextRef theOffscreenContext = CGBitmapContextCreate(NULL,
                                                             (size_t)CGRectGetWidth(theNewRect),
                                                             (size_t)CGRectGetHeight(theNewRect),
                                                             CGImageGetBitsPerComponent(theImage.CGImage),
                                                             0,
                                                             CGImageGetColorSpace(theImage.CGImage),
                                                             CGImageGetBitmapInfo(theImage.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect theImageLocation = CGRectMake(theBorderSize, theBorderSize, theImage.size.width, theImage.size.height);
    CGContextDrawImage(theOffscreenContext, theImageLocation, theImage.CGImage);
    CGImageRef theBorderImageRef = CGBitmapContextCreateImage(theOffscreenContext);
    UIImage *theBorderImage = [UIImage imageWithCGImage:theBorderImageRef];
    
    // Clean up
    CGContextRelease(theOffscreenContext);
    CGImageRelease(theBorderImageRef);
    
    // Create a mask to make the border transparent, and combine it with the image
    UIImage *theTransparentBorderImage = [theBorderImage imageWithTransparentBorderOfSize:theBorderSize];
    
    return theTransparentBorderImage;
}

- (UIImage *)imageWithBorderOfSize:(NSUInteger)theBorderSize color:(UIColor *)theBorderColor {
    UIImage *theImage = [self imageWithTransparentBorderOfSize:theBorderSize];
    
    // Build context
    CGContextRef theOffscreenContext = CGBitmapContextCreate(NULL,
                                                             (size_t)theImage.size.width,
                                                             (size_t)theImage.size.height,
                                                             CGImageGetBitsPerComponent(theImage.CGImage),
                                                             0,
                                                             CGImageGetColorSpace(theImage.CGImage),
                                                             CGImageGetBitmapInfo(theImage.CGImage));
    
    // Draw
    CGContextSetFillColorWithColor(theOffscreenContext, theBorderColor.CGColor);
    CGContextFillRect(theOffscreenContext, CGRectMake(0, 0, theImage.size.width, theImage.size.height));
    CGContextDrawImage(theOffscreenContext, CGRectMake(0, 0, theImage.size.width, theImage.size.height), theImage.CGImage);
    CGImageRef theBorderImageRef = CGBitmapContextCreateImage(theOffscreenContext);
    UIImage *theBorderImage = [UIImage imageWithCGImage:theBorderImageRef];
    
    // Clean up
    CGContextRelease(theOffscreenContext);
    CGImageRelease(theBorderImageRef);
    
    return theBorderImage;
}

@end
