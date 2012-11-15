//
//  UIImage+LXSupport.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 26/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import "UIImage+LXSupport.h"

@implementation UIImage (LXSupport)

#pragma mark - Alpha

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
+ (UIImage *)borderMaskImageOfBorderSize:(CGFloat)theBorderSize forImageSize:(CGSize)theImageSize scale:(CGFloat)theScale orientation:(UIImageOrientation)theOrientation {
    NSParameterAssert(theScale != 0.0f);
    
    CGFloat theBorderSizeInPixel = theBorderSize * theScale;
    
    CGFloat theImageWidthInPixel = theImageSize.width * theScale;
    CGFloat theImageHeightInPixel = theImageSize.height  * theScale;
    
    CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the image size
    CGContextRef theMaskContext = CGBitmapContextCreate(NULL,
                                                        (size_t)theImageWidthInPixel,
                                                        (size_t)theImageHeightInPixel,
                                                        8, // 8-bit grayscale
                                                        0,
                                                        theColorSpace,
                                                        kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(theMaskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(theMaskContext, CGRectMake(0.0f, 0.0f, theImageWidthInPixel, theImageHeightInPixel));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(theMaskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(theMaskContext, CGRectMake(theBorderSizeInPixel, theBorderSizeInPixel, theImageWidthInPixel - (theBorderSizeInPixel * 2.0f), theImageHeightInPixel - (theBorderSizeInPixel * 2.0f)));
    
    // Get an image of the context
    CGImageRef theMaskImageRef = CGBitmapContextCreateImage(theMaskContext);
    UIImage *theMaskImage = [UIImage imageWithCGImage:theMaskImageRef scale:theScale orientation:theOrientation];
    
    // Clean up
    CGColorSpaceRelease(theColorSpace);
    CGContextRelease(theMaskContext);
    CGImageRelease(theMaskImageRef);
    
    return theMaskImage;
}

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
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect theRect = (CGRect){ .origin = CGPointZero, .size = self.size };
    [self drawInRect:theRect];
    UIImage *theImageWithAlpha = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size overlay around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)imageWithTransparentBorderOfSize:(CGFloat)theBorderSize {
    UIImage *theImage = [self imageWithAlpha];
    UIImage *theMaskImage = [UIImage borderMaskImageOfBorderSize:theBorderSize forImageSize:theImage.size scale:theImage.scale orientation:theImage.imageOrientation];
    CGImageRef theTransparentBorderImageRef = CGImageCreateWithMask(theImage.CGImage, theMaskImage.CGImage);
    UIImage *theTransparentBorderImage = [UIImage imageWithCGImage:theTransparentBorderImageRef scale:theImage.scale orientation:theImage.imageOrientation];
    
    // Clean up
    CGImageRelease(theTransparentBorderImageRef);
    
    return theTransparentBorderImage;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)imageWithAdditionalTransparentBorderOfSize:(CGFloat)theBorderSize {
    // If the image does not have an alpha layer, add one
    UIImage *theImage = [self imageWithAlpha];
    
    CGRect theNewRect = CGRectMake(0.0f, 0.0f, theImage.size.width + (theBorderSize * 2.0f), theImage.size.height + (theBorderSize * 2.0f));
    
    UIGraphicsBeginImageContextWithOptions(theNewRect.size, NO, theImage.scale);
    [theImage drawInRect:CGRectInset(theNewRect, theBorderSize, theBorderSize)];
    UIImage *theBorderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create a mask to make the border transparent, and combine it with the image
    UIImage *theTransparentBorderImage = [theBorderImage imageWithTransparentBorderOfSize:theBorderSize];
    
    return theTransparentBorderImage;
}

- (UIImage *)imageWithBorderOfSize:(CGFloat)theBorderSize color:(UIColor *)theBorderColor {
    UIImage *theImage = [self imageWithTransparentBorderOfSize:theBorderSize];
    
    UIGraphicsBeginImageContextWithOptions(theImage.size, NO, theImage.scale);
    CGContextRef theOffscreenContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(theOffscreenContext, theBorderColor.CGColor);
    CGContextFillRect(theOffscreenContext, CGRectMake(0.0f, 0.0f, theImage.size.width, theImage.size.height));
    [theImage drawInRect:CGRectMake(0.0f, 0.0f, theImage.size.width, theImage.size.height)];
    UIImage *theBorderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theBorderImage;
}

#pragma mark - Resize

+ (CGAffineTransform)affineTransformForSize:(CGSize)theSize withImageOrientation:(UIImageOrientation)theImageOrientation {
    CGAffineTransform theTransform = CGAffineTransformIdentity;
    
    switch (theImageOrientation) {
        case UIImageOrientationDown: // EXIF = 3
        case UIImageOrientationDownMirrored: { // EXIF = 4
            theTransform = CGAffineTransformTranslate(theTransform, theSize.width, theSize.height);
            theTransform = CGAffineTransformRotate(theTransform, M_PI);
        } break;
        case UIImageOrientationLeft: // EXIF = 6
        case UIImageOrientationLeftMirrored: { // EXIF = 5
            theTransform = CGAffineTransformTranslate(theTransform, theSize.width, 0.0f);
            theTransform = CGAffineTransformRotate(theTransform, M_PI_2);
        } break;
        case UIImageOrientationRight: // EXIF = 8
        case UIImageOrientationRightMirrored: { // EXIF = 7
            theTransform = CGAffineTransformTranslate(theTransform, 0.0f, theSize.height);
            theTransform = CGAffineTransformRotate(theTransform, -M_PI_2);
        } break;
        
        case UIImageOrientationUp: // EXIF = 1
        case UIImageOrientationUpMirrored: { // EXIF = 2
            // Do nothing...
        } break;
    }
    
    // Mirrored only...
    switch (theImageOrientation) {
        case UIImageOrientationUpMirrored: // EXIF = 2
        case UIImageOrientationDownMirrored: { // EXIF = 4
            theTransform = CGAffineTransformTranslate(theTransform, theSize.width, 0.0f);
            theTransform = CGAffineTransformScale(theTransform, -1.0f, 1.0f);
        } break;
        case UIImageOrientationLeftMirrored:  // EXIF = 5
        case UIImageOrientationRightMirrored: { // EXIF = 7
            theTransform = CGAffineTransformTranslate(theTransform, theSize.height, 0.0f);
            theTransform = CGAffineTransformScale(theTransform, -1.0f, 1.0f);
        } break;
        
        default: {
            // Do nothing...
        } break;
    }
    
    return theTransform;
}

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImageToBounds:(CGRect)theBounds {
    CGImageRef theCroppedImageRef = CGImageCreateWithImageInRect(self.CGImage, theBounds);
    UIImage *theCroppedImage = [UIImage imageWithCGImage:theCroppedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(theCroppedImageRef);
    return theCroppedImage;
}

- (UIImage *)resizedImageWithSize:(CGSize)theSize affineTransform:(CGAffineTransform)theAffineTransform drawTransposed:(BOOL)theDrawTransposed interpolationQuality:(CGInterpolationQuality)theInterpolationQuality {
    UIGraphicsBeginImageContextWithOptions(theSize, ![self hasAlpha], self.scale);
    CGContextRef theOffscreenContext = UIGraphicsGetCurrentContext();
    
    //http://developer.apple.com/library/ios/#qa/qa1708/_index.html
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(theOffscreenContext, 0.0f, theSize.height);
    CGContextScaleCTM(theOffscreenContext, 1.0f, -1.0f);
    CGContextSetBlendMode(theOffscreenContext, kCGBlendModeCopy);
    
    CGContextConcatCTM(theOffscreenContext, theAffineTransform);
    CGContextSetInterpolationQuality(theOffscreenContext, theInterpolationQuality);
    CGContextDrawImage(theOffscreenContext, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), self.CGImage);
    UIImage *theResizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theResizedImage;
}

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)theContentMode size:(CGSize)theSize interpolationQuality:(CGInterpolationQuality)theInterpolationQuality {
    CGFloat theHorizontalRatio = theSize.width / self.size.width;
    CGFloat theVerticalRatio = theSize.height / self.size.height;
    
    CGFloat theScale = 1.0f;
    switch (theContentMode) {
        case UIViewContentModeScaleAspectFill: {
            theScale = MAX(theHorizontalRatio, theVerticalRatio);
        } break;
        case UIViewContentModeScaleAspectFit: {
            theScale = MIN(theHorizontalRatio, theVerticalRatio);
        } break;
        default: {
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", theContentMode];
        } break;
    }
    
    CGSize theImageSize = CGSizeMake(self.size.width * theScale, self.size.height * theScale);
    CGPoint theImageOffset = CGPointMake((theSize.width - theImageSize.width) / 2.0f, (theSize.height - theImageSize.height) / 2.0f);
    
    CGAffineTransform theAffineTransform = [UIImage affineTransformForSize:theSize withImageOrientation:self.imageOrientation];
    theAffineTransform = CGAffineTransformTranslate(theAffineTransform, theImageOffset.x, theImageOffset.y);
    theAffineTransform = CGAffineTransformScale(theAffineTransform, theScale, theScale);
    
    BOOL theDrawTransposed = NO;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored: {
            theDrawTransposed = YES;
        } break;
        default: {
            theDrawTransposed = NO;
        } break;
    }
    
    return [self resizedImageWithSize:theSize affineTransform:theAffineTransform drawTransposed:theDrawTransposed interpolationQuality:theInterpolationQuality];
}

@end
